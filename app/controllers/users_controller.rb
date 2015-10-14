class UsersController < ApplicationController
  #before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,:following, :followers,:follow, :unfollow]
  before_action :correct_user, only:[:edit, :update]
  before_action :admin_user,     only: :destroy
  require 'will_paginate/array'
  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(page: params[:page],:per_page => 15)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page])
#    debugger we can use debugger here !
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])

  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.save
  @user.send_activation_email
  flash[:info] = "Please check your email to activate your account."
  redirect_to root_url
else
  render 'new'
end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
       redirect_to @user
   else
     render 'edit'
   end

  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

def follow
  @user = User.find(params[:id])

  if current_user
    if current_user == @user
      flash[:error] = "You cannot follow yourself."
    else
      current_user.follow(@user)
      #RecommenderMailer.new_follower(@user).deliver if @user.notify_new_follower
      flash[:notice] = "You are now following #{@user.name}."
      redirect_to @user
    end
  else
    flash[:error] = "You must <a href='/users/sign_in'>login</a> to follow #{@user.name}."
  end
end

def unfollow
  @user = User.find(params[:id])

  if current_user
    current_user.stop_following(@user)
    flash[:notice] = "You are no longer following #{@user.name}."
    redirect_to @user
  else
    flash[:error] = "You must <a href='/users/sign_in'>login</a> to unfollow #{@user.monniker}.".html_safe
  end
end

def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following_users.paginate(page: params[:page],per_page: 6)
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers_by_type('User').paginate(page: params[:page],per_page: 6)
    render 'show_follow'
  end

  private
    # Use callbacks to share common setup or constraints between actions.


    # allow only correct user to edit data!
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email,:password, :password_confirmation)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
