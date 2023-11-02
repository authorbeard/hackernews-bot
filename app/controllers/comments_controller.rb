class CommentsController < ApplicationController
  def index 
    @story = Story.joins(:comments).find(params[:story_id])
    @comments = @story.comments
    respond_to do |format|
      format.turbo_stream
    end
  end

  private 

  def comment_params 
    params.require(:story_id)
  end
end
