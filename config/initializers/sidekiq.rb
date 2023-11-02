Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1') }
  config.on(:startup) do
    Sidekiq.set_schedule(
      'FetchTopStoriesJob',
      {
        'every': '1h',
        'class': 'FetchTopStoriesJob'
      }
    )
  end
end
Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1') }
end

