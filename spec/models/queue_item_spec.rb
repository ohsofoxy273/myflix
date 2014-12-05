require 'spec_helper'

describe QueueItem do
	it {should belong_to :user}
	it {should belong_to :video}
	it {should validate_numericality_of(:position).only_integer}

	describe "#video_title" do
		it "returns the title of the associated video" do
			video = Fabricate(:video, title: "Must Love Dogs")
			queue_item = Fabricate(:queue_item, video: video)
			expect(queue_item.video_title).to eq("Must Love Dogs")
		end
	end

	describe "#rating" do
		it "returns the rating of the associated video from the review when present" do
			video = Fabricate(:video)
			user = Fabricate(:user)
			review = Fabricate(:review, video: video, user: user, rating: 4)
			queue_item = Fabricate(:queue_item, video: video, user: user)
			expect(queue_item.rating).to eq(4)
		end

		it "returns nil when the review is absent" do
			video = Fabricate(:video)
			user = Fabricate(:user)
			queue_item = Fabricate(:queue_item, video: video, user: user)
			expect(queue_item.rating).to be_nil
		end
	end

	describe "#rating=()" do
		it "changes the rating of the review if the review is present" do
			video = Fabricate(:video)
			user = Fabricate(:user)
			review = Fabricate(:review, user: user, video: video, rating: 2)
			queue_item = Fabricate(:queue_item, user: user, video: video)
			queue_item.rating = 4
			expect(Review.first.rating).to eq(4)
		end

		it "changes the rating of the review if the review is present" do
			video = Fabricate(:video)
			user = Fabricate(:user)
			review = Fabricate(:review, user: user, video: video, rating: 2)
			queue_item = Fabricate(:queue_item, user: user, video: video)
			queue_item.rating = nil
			expect(Review.first.rating).to be_nil
		end

		it "creates a review with the rating if the review is not present" do
			video = Fabricate(:video)
			user = Fabricate(:user)
			queue_item = Fabricate(:queue_item, user: user, video: video)
			queue_item.rating = 3
			expect(Review.first.rating).to eq(3)
		end
	end

	describe "#category_name" do
		it "returns the category name of the associated video" do
			category = Fabricate(:category, name: "comedies")
			video = Fabricate(:video, category: category)
			queue_item = Fabricate(:queue_item, video: video)
			expect(queue_item.category_name).to eq("comedies")
		end
	end

	describe "#category" do
		it "returns the category of the associated video" do
			category = Fabricate(:category)
			video = Fabricate(:video, category: category)
			queue_item = Fabricate(:queue_item, video: video)
			expect(queue_item.category).to eq(category)
		end
	end

end