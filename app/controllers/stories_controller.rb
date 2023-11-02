class StoriesController < ApplicationController
  def index 
    @latest_story = Story.order(posted_at: :desc).first
    @stories = Story.order(top_stories_idx: :asc).limit(10)

    puts @stories
  end
end