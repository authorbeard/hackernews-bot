class StoriesController < ApplicationController
  def index 
    @latest_story = Story.order(posted_at: :desc).first
    @stories = Story.order(score: :desc).limit(10)

  end
end