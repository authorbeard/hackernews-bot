class FetchStoryCommentsJob < ApplicationJob
  def perform(opts)
    opts[:comment_ids].each do |comment_id|
      comment_hash = HackerNewsClient.get_story(comment_id)
      comment_for_update = Comment.find_or_initialize_by(hn_id: comment_hash["id"])
      comment_for_update.assign_attributes(
        by: comment_hash["by"],
        text: comment_hash["text"],
        hn_id: comment_hash["id"],
        hn_type: comment_hash["type"],
        story_id: opts[:story].id,
        posted_at: Time.at(comment_hash["time"])
      )
      
      comment_for_update.save!
    end
  end
end