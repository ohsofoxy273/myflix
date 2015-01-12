class User < ActiveRecord::Base
  include Tokenable

  before_save { self.email = email.downcase }
  has_many :queue_items, -> {order :position}
  has_secure_password
  has_many :reviews, -> {order "created_at DESC"}
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, 
            uniqueness: { case_sensitive: false }, 
            presence: true, 
            length: {maximum: 250},
            format: { with: VALID_EMAIL_REGEX }

  validates :name,  
            presence: true, 
            length: {maximum: 50}

  validates :password, length: {minimum: 6}

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end

  def queued_video?(video)
    queue_items.where(video: video.id).present?
  end

  def follow(another_user)
    following_relationships.create(leader: another_user) if can_follow? another_user
  end

  def follows?(another_user)
    self.following_relationships.map(&:leader).include?(another_user)
  end

  def can_follow?(another_user)
    !(self.follows?(another_user) || self == another_user)
  end

end
  