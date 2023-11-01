FactoryBot.define do 
  factory :story do 
    title { Faker::Music.album }
    by { Faker::Music::Hiphop.artist }
    type { "story" }
    posted_at { Faker::Time.between(from: DateTime.now - 30, to: DateTime.now) }
    text { Faker::Hipster.paragraph }
    score { Faker::Number.between(from: 1, to: 100) }
    hn_id { Faker::Number.number(digits: 8) }
  end
end