require 'spec_helper'

describe Category do
	it "saves a valid Category" do
		comedies = Category.new(name: "comedies")
		comedies.save
		expect(Category.first).to eq(comedies)
	end

	it { should have_many :videos }

	describe "#recent_videos" do
		let(:comedies) {Category.create(name: "comedies")}
		it "returns videos in reverse chronological order" do
			futarama = Video.create(title: "Futarama", description: "futaristic", category_id: comedies.id, created_at: 1.day.ago)
			family = Video.create(title: "Family Guy", description: "familial", category_id: comedies.id)	
			expect(comedies.recent_videos).to eq([family, futarama])
		end

		it "returns all the videos if there are less than 6" do
			futarama = Video.create(title: "Futarama", description: "futaristic", category_id: comedies.id, created_at: 1.day.ago)
			family = Video.create(title: "Family Guy", description: "familial", category_id: comedies.id)	
			expect(comedies.recent_videos.count).to eq(2)	
		end

		it "returns 6 videos if there are more than 6" do
			7.times {Video.create(title: "foo", description: "bar", category_id: comedies.id)}
			expect(comedies.recent_videos.count).to eq(6)
		end

		it "returns the most recent 6 videos" do
			6.times {Video.create(title: "foo", description: "bar", category_id: comedies.id)}
			tonight_show = Video.create(title: "foo", description: "bar", category_id: comedies.id, created_at: 1.day.ago)
			expect(comedies.recent_videos).not_to include(tonight_show)	
		end

		it "returns an empty array if the category has no videos" do
			expect(comedies.recent_videos).to eq([])
		end	
	end
end
