class FetchStoryCommentsJob < ApplicationJob
  def peform(story)
    story.kids.each do |kid|
      comment = HackerNewsClient.get_story(kid)
    end
  end
end