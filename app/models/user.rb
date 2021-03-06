class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :disease
  has_many :messages, dependent: :destroy
  has_many :chatrooms, dependent: :destroy

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  has_many :topics, dependent: :destroy
  has_many :topic_likes

  has_many :posts, dependent: :destroy
  has_many :post_likes

  has_one_attached :photo

  has_many :follower_relationships, foreign_key: :following_id, class_name: 'Follow'
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :following_relationships, foreign_key: :follower_id, class_name: 'Follow'
  has_many :following, through: :following_relationships, source: :following


  include PgSearch::Model
  multisearchable against: [:first_name, :last_name]
  #methods to the User model to have a simpler way of following and unfollowing users
  # and to check if a user is following another


  def follow(user_id)
    following_relationships.create(following_id: user_id)
  end

  def unfollow(user_id)
    following_relationships.find_by(following_id: user_id).destroy
  end

  def is_following?(user_id)
    relationship = Follow.find_by(follower_id: id, following_id: user_id)
    return true if relationship
  end


end
