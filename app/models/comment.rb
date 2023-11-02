class Comment < ApplicationRecord 
  belongs_to :story

  validates_presence_of :text, :hn_id
  validates_inclusion_of :hn_type, in: %w[comment]
  validates_uniqueness_of :hn_id
end