class AddUniquenessIndexToStories < ActiveRecord::Migration[7.0]
  def up
    remove_index :stories, :hn_id, if_exists: true
    add_index :stories, :hn_id, unique: true
  end

  def down
    remove_index :stories, :hn_id, if_exists: true
  end
end
