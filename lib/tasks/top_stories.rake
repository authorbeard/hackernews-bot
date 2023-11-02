namespace :top_stories do 
  desc 'Fetch top stories from Hacker News API, enqueue jobs to fetch their comments' 
  task fetch_now: :environment do
    FetchTopStoriesJob.perform_later 
  end

  desc 'Set up hourly fetch for top stories' 
  task fetch_hourly: :environment do
    
  end
end