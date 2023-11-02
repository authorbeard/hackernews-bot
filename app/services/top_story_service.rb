class TopStoryService 
  attr_reader :story_ids, :top_stories, :error
  def self.fetch
    new.tap { |svc| svc.fetch_top_stories }
  end

  def initialize 
    @top_stories = []
  end

  def fetch_top_stories
    @story_ids = client.get_top_stories
    while @top_stories.length < 10
      story = client.get_story(@story_ids.pop)
      top_stories << story if story["type"] == "story"
    end  

    save_top_stories

  rescue HackerNewsError => e
    errors << e.message
  end

  def save_top_stories
    top_stories.each_with_index do |story, idx|
      s = Story.where(top_stories_idx: idx).or(Story.where(hn_id: story["id"]))
      

    end
  end

  private 

  def client 
    @client ||= HackerNewsClient
  end
end