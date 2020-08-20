class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :reverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :pending_friendships, -> { where(status: nil) }, class_name: 'Friendship', foreign_key: :user_id
  has_many :pending_friends, through: :pending_friendships, source: :friend
  has_many :incoming_friendships, -> { where(status: nil) }, class_name: 'Friendship', foreign_key: :friend_id
  has_many :friend_requests, through: :incoming_friendships, source: :user

  def friends
    friends_array = friendships.map { | friendship | friendship.friend if friendship.status }
    reverse_friends_array = friendships.map { | friendship | friendship.user if friendship.status }
    all_friends_array = friends_array + reverse_friends_array
    all_friends_array.compact
  end

  def pending_requests
    friendships.map { | friendship | friendship.friend unless friendship.status }.compact
  end

  def friend_requests
    friendships.map { | friendship | friendship.user unless friendship.status }.compact
  end
  
  def confirm_friendship(user)
    friendship = reverse_friendships.find { | f | f.user == user}
    friendship.status = true
    friendship.save
  end

  def reject_friendship(user)
    friendship = reverse_friendships.find { | f | f.user == user}
    friendship.destroy
  end

  def cancel_friendship(user)
    friendship = friendships.find { | f | f.friend == user}
    friendship.destroy       
  end

  def friend?(user)
    friends.include?(user)
  end

  def send_friend_request(user, friend)
    new_friend_request = user.friendships.new(friend_id: friend.id, status: nil)
    new_friend_request.save
  end
end
