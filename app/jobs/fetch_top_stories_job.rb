class FetchTopStoriesJob < ApplicationJob
  sidekiq_options queue: 'critical'
  
  def perform
    TopStoriesService.fetch 
  end
end