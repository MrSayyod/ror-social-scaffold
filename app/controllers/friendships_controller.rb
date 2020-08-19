class FriendshipsController < ApplicationController
  def create
    @friendship = current_user.friendships.build(friend_id: params[:user_id])
    @friendship.save
    redirect_to users_path
  end

  def accept
    @friend = User.find_by(id: params[:user_id])
    current_user.confirm_friend(@friend)
    redirect_to users_path, notice: "Now, #{@friend} is your friend"
  end

  def reject
    current_user.reject_friend(User.find_by(id: params[:user_id]))
    redirect_to users_path, notice: "Friendship rejected!"
  end

  def cancel
    current_user.cancel_request(User.find_by(id: params[:user_id]))
    redirect_to users_path, notice "Friendship cancelled!"
  end
end
