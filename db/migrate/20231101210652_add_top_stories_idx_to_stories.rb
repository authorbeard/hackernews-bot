class AddTopStoriesIdxToStories < ActiveRecord::Migration[7.0]
  def change
    add_column :stories, :top_stories_idx, :integer
  end
end
