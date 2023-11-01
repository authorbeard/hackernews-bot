class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string      :by
      t.text        :text
      t.timestamptz :posted_at
      t.integer     :score
      t.string      :hn_id
      t.string      :hn_type
      t.references  :story
      t.timestamps
    end
  end
end
