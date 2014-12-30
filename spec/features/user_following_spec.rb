require 'spec_helper'

feature 'User following' do
	scenario "user follows and unfollows someone" do
		alice = Fabricate(:user)
		category = Fabricate(:category)
		video = Fabricate(:video, category: category)
		Fabricate(:review, user: alice, video: video)

		sign_in
		click_on_video_on_homepage(video)
	
		click_link alice.name
		click_link "Follow"
		expect(page).to have_content(alice.name)

		unfollow(alice)
		expect(page).not_to have_content(alice.name)
	end

	def unfollow(user)
		find("a[data-method='delete']").click
	end
end