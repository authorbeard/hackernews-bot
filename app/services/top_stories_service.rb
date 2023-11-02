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

    #   #NOTE: need to come back to this later
    #   db_stories = Story.where(top_stories_idx: idx).or(Story.where(hn_id: story["id"]))
    # debugger
    #   matching_id, old_top_story = db_stories.partition { |s| s.hn_id == story["id"].to_s }
      
    #   # NOTE: This should be async; will move it to Sidekiq later
    #   old_top_story.update(top_stories_idx: nil) if old_top_story.present?
      s = Story.find_or_initialize_by(hn_id: story["id"]) 
      
      s.assign_attributes(
        title: story["title"],
        hn_type: story["type"],
        by: story["by"],
        posted_at: Time.at(story["time"]),
        text: story["text"],
        score: story["score"],
        hn_id: story["id"],
        descendant_count: story["descendants"],
        top_stories_idx: idx
      )

      s.save!

    rescue ActiveRecord::RecordInvalid => e
      errors << "#{e.message} | #{e.record.hn_id} | #{e.record.text}"
    end
  end

  private 

  def client 
    @client ||= HackerNewsClient
  end
end