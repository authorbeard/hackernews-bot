class Story < ApplicationRecord
  validates_presence_of :title, :text, :score, :hn_id
  validates_inclusion_of :type, in: %w[story]
  validates_uniqueness_of :hn_id

# HN response includes ':kids' array; not adding to model; poss create scope
end