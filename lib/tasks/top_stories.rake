namespace :top_stories do 
  desc 'Fetch top stories from Hacker News API, enqueue jobs to fetch their comments' 
  task fetch_now: :environment do
    FetchTopStoriesJob.new.perform
  end

  desc 'schedule hourly refresh' 
  task schedule_refresh: :environment do
    Sidekiq.set_schedule(
      'FetchTopStoriesJob',
      {
        'every': '1h',
        'class': 'FetchTopStoriesJob'
      }
    )
  end
end