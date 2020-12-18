class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: :friend_id

  has_many :pending_friendships, -> { where(status: -1) }, class_name: 'Friendship', foreign_key: :user_id
  has_many :pending_friends, through: :pending_friendships, source: :friend

  has_many :incoming_friendships, -> { where(status: -1) }, class_name: 'Friendship', foreign_key: :friend_id
  has_many :friend_requests, through: :incoming_friendships, source: :user

  has_many :confirmed_friendships, -> { where(status: 1) }, class_name: 'Friendship'
  has_many :friends, through: :confirmed_friendships

  def friend?(user)
    friends.include?(user)
  end

  def confirm_friendship(user)
    friendship = incoming_friendships.find_by(user_id: user)
    friendship.update(status: 1)
    Friendship.create(user: friendship.friend, friend: friendship.user, status: 1)
  end

  def reject_friend_request(user)
    friend_request = inverse_friendships.find { |friendship| friendship.user == user if friendship.status == -1 }
    friend_request.status = 0
    friend_request.save
  end

  def send_friend_request(user, friend)
    new_friend_request = user.friendships.new(friend_id: friend.id, status: -1)
    new_friend_request.save
  end

  def friends_and_own_posts
    Post.where(user: (friends + self))
  end
end
