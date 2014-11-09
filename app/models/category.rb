class Category < ActiveRecord::Base
	has_many :videos

		def six_random_videos
			self.videos.limit(6).order("RANDOM()")
		end
end
