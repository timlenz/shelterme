class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy
  before_filter :admin_user,     only: :destroy

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Comment added for #{@micropost.pet.name}."
      redirect_to :back
    else
      flash[:error] = "Comment too long."
      redirect_to :back
    end
  end

  def destroy
    @micropost.destroy
    redirect_to :back
  end
  
  private
    
    def admin_user
      @micropost = Micropost.find_by_id(params[:id])
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
    rescue
      redirect_to root_path
    end
end