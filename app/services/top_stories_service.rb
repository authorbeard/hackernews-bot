class TopStoriesService 
  attr_reader :story_ids, :top_stories, :errors
  def self.fetch
    new.tap { |svc| svc.fetch_top_stories }
  end

  def initialize 
    @top_stories = []
    @errors = []
  end

  def fetch_top_stories
    @story_ids = client.get_top_stories
    while @top_stories.length < 10
      story = client.get_story(@story_ids.pop)
      top_stories << story if story["type"] == "story"
    end  

    save_top_stories

  rescue HackerNewsClient::APIError => e
    errors << e.message
  end

  def save_top_stories
    top_stories.each_with_index do |story, idx|
      next if story["type"] != "story"

    # TODO: extract to separate method and create sidekiq job fo updating old records
    db_stories = Story.where(top_stories_idx: idx).or(Story.where(hn_id: story["id"]))
    matching_id, old_top_stories = db_stories.partition { |s| s.hn_id == story["id"].to_s }

    #   # NOTE: This should be async; will move it to Sidekiq later
      old_top_stories.each{|s| RemoveTopStoriesIdxJob.perform_later(s) } if old_top_stories.any?
      
      story_for_update = matching_id.any? ? matching_id.first : Story.new 

      story_for_update.assign_attributes(
        title: story["title"],
        hn_type: story["type"],
        by: story["by"],
        posted_at: Time.at(story["time"]),
        text: story["text"],
        score: story["score"],
        hn_id: story["id"],
        descendant_count: story["descendants"],
        top_stories_idx: idx,
      )

      if story_for_update.valid?
        story_for_update.save!
        FetchStoryCommentsJob.perform_later({
          story: story_for_update,
          comment_ids: story['kids']
      })
      else
        errors << "#{story_for_update.errors.full_messages.join(', ')} | hn_id: #{story_for_update.hn_id} | title: #{story_for_update.title}"
      end

    rescue ActiveRecord::RecordInvalid => e
      errors << "#{e.message} | hn_id: #{e.record.hn_id} | title: #{e.record.title}"
    end
  end

  private 

  def client 
    @client ||= HackerNewsClient
  end
end