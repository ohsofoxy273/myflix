require 'spec_helper'


describe Category do
	it "saves a valid Category" do
		comedies = Category.new(name: "comedies")
		comedies.save
		expect(Category.first).to eq(comedies)
	end

	it "has many videos" do
		should have_many :videos
	end

	describe "#six_random_videos" do
		it "returns six videos" do
			drama = Category.create(name: 'drama')
			12.times do
				Video.create(title: "Drama!",
										 description: "So much drama.",
										 category_id: drama.id)
			end
			expect(drama.videos.count).to eq(12)
			vids = drama.six_random_videos
			expect(vids.count).to eq(6)
		end
	end
end
