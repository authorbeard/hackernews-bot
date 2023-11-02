class RemoveTopStoriesIdxJob < ApplicationJob
  sidekiq_options retry: 0

  def perform(story)
    story.update!(top_stories_idx: nil)
  end
end