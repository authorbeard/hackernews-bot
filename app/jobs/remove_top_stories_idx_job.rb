class RemoveTopStoriesIdxJob < ApplicationJob
  def perform(story)
    story.update!(top_stories_idx: nil)
  end
end