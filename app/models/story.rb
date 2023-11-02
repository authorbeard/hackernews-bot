class Story < ApplicationRecord
  validates_presence_of :title, :hn_id
  validates_inclusion_of :hn_type, in: %w[story]
  validates_uniqueness_of :hn_id

  has_many :comments

  scope :top_ten, -> { order(top_stories_idx: :asc).limit(10) }
# HN response includes ':kids' array; not adding to model; poss create scope
end