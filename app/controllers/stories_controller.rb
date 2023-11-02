class StoriesController < ApplicationController
  def index 
    @last_updated = Story.maximum(:updated_at)
    @stories = Story.top_ten

    puts @stories
  end
end