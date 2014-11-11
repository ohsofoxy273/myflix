class Category < ActiveRecord::Base
	has_many :videos, -> { order("title")}

	def six_random_videos
		self.videos.limit(6).order("RANDOM()")
	end
end
