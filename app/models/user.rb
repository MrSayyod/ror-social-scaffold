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
end
