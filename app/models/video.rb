class Video < ActiveRecord::Base
  belongs_to :category
  validates_presence_of :title, :description
  has_many :reviews

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader
  
  def self.search_by_title(search_term)
    result = where("title ILIKE ?", "%#{search_term}%")
    result.blank? == false ? result : []
  end

end
