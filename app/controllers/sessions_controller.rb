class SessionsController < ApplicationController
  
  def new
    session[:return_to] ||= request.referer
  end
  
  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      flash[:notice] = "You are now logged in as #{user.name}."
      redirect_back_or user
    else
      flash[:error] = 'Invalid email or password'
      render 'new'
    end
    cookies.delete :location
    cookies.delete :shelter_id
    cookies.permanent[:history] = " "
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end
