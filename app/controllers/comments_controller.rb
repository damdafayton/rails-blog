class CommentsController < ApplicationController
  load_and_authorize_resource

  def create
    new_comment = Comment.new(create_params)
    new_comment.author_id = current_user.id

    # respond_to block
    respond_to do |new|
      new.html do
        if new_comment.save
          # success message
          flash[:success] = 'Comment saved successfully'
        else
          # error message
          flash.now[:error] = 'Error: Comment could not be saved'
        end
        redirect_to author_post_path(params[:author_id], params[:post_id])
      end
    end
  end

  def destroy
    if @comment.destroy
      flash[:success] = 'Comment deleted successfully'
    else
      flash[:error] = 'Error: Comment could not be deleted'
    end
    redirect_back(fallback_location: root_path)
  end

  private

  # use create_ for cancancan
  def create_params
    params.require(:comment).permit(:text, :post_id)
  end
end
