FactoryBot.define do 
  factory :comment do
    by      { Faker::Music::Hiphop.artist }
    text    { Faker::Hipster.paragraph }
    hn_id   { Faker::Number.number(digits: 8) }
    story
    hn_type { "comment" }
  end
end