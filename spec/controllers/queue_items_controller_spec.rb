require 'spec_helper'

describe QueueItemsController do
	describe "GET index" do
		it "sets the @queue_items to the queue items of the logged in user" do
			alice = Fabricate(:user)
			session[:user_id] = alice.id
			queue_item1 = Fabricate(:queue_item, user: alice)
			queue_item2 = Fabricate(:queue_item, user: alice)
			get :index
			expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
		end

		it "redirects to the sign in page for unauthenticated users" do
			get :index
			expect(response).to redirect_to new_session_path
		end
	end

	describe "POST create" do
		it "redirects to the my_queue page" do
			session[:user_id] = Fabricate(:user).id
			video = Fabricate(:video)
			post :create, video_id: video.id
			expect(response).to redirect_to my_queue_path
		end

		it "creates a queue item" do
			session[:user_id] = Fabricate(:user).id
			video = Fabricate(:video)
			post :create, video_id: video.id
			expect(QueueItem.count).to eq(1)
		end

		it "creates a queue item that is associated with the video" do
			session[:user_id] = Fabricate(:user).id
			video = Fabricate(:video)
			post :create, video_id: video.id
			expect(QueueItem.first.video).to eq(video)
		end
		
		it "creates a queue item that is associated with the signed in user" do
			user = Fabricate(:user)
			video = Fabricate(:video)
			session[:user_id] = user.id
			post :create, video_id: video.id
			expect(QueueItem.first.user).to eq(user)
		end

		it "puts the video as the last one in the queue" do 
			user = Fabricate(:user)
			session[:user_id] = user.id
			monk = Fabricate(:video)
			Fabricate(:queue_item, user: user, video: monk)
			south_park = Fabricate(:video)
			post :create, user: user, video_id: south_park.id
			south_park_queue_item = QueueItem.where(user_id: user.id, video_id: south_park.id).first
			expect(south_park_queue_item.position).to eq(2)
		end

		it "does not add the video to the queue if it is already in the queue" do
			user = Fabricate(:user)
			session[:user_id] = user.id
			monk = Fabricate(:video)
			Fabricate(:queue_item, user: user, video: monk)
			post :create, user: user, video_id: monk.id
			expect(user.queue_items.count).to eq(1)
		end

		it "redirects to the sign in page for unauthenticated users" do
			post :create, video_id: 3
			expect(response).to redirect_to new_session_path
		end
	end
end