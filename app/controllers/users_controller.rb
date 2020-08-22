class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all.order('created_at DESC')
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
    @friend_requests = @user.friend_requests
    @pending_friends = @user.pending_friends
    @friends = @user.friends.uniq
  end

  def make_friend
    @friend = User.find(params[:friend_id])
    @invitation = current_user.confirm_friendship(@friend)
    flash[:notice] = 'You have become friends!'
    redirect_to user_path(current_user)
  end

  def send_friend_request
    @friend = User.find(params[:friend_id])
    @send_friend_request = current_user.send_friend_request(current_user, @friend)
    flash[:notice] = 'You have sent a friend request successfully!'
    redirect_to user_path(current_user)
  end

  def ignore_friend_request
    @requst_sender = User.find(params[:friend_id])
    @ignore_friendship = current_user.reject_friend_request(@requst_sender)
    flash[:notice] = 'You have deleted friend request!'
    redirect_to user_path(current_user)
  end
end
