class Story < ApplicationRecord
  validates_presence_of :title, :text, :score, :hn_id
  validates_inclusion_of :hn_type, in: %w[story]
  validates_uniqueness_of :hn_id

  has_many :comments
# HN response includes ':kids' array; not adding to model; poss create scope
end