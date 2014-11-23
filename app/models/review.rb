class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates :rating, numericality: {greater_than: 0, less_than: 6}
  validates :content, presence: true  
end
