class CreateStories < ActiveRecord::Migration[7.0]
  def change
    create_table :stories do |t|
      t.string      :title
      t.string      :type
      t.string      :by
      t.timestamptz :posted_at
      t.text        :text
      t.integer     :score
      t.string      :hn_id
      t.integer     :descendant_count
      t.timestamps
    end
  end
end
