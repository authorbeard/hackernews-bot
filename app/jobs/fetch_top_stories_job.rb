class FetchTopStoriesJob < ApplicationJob
  def perform
    TopStoriesService.fetch 
  end
end