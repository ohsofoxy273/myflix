require 'spec_helper'

describe VideosController do

	describe "GET show" do
	 	it "assigns the @videos variable with an authenticated user" do
	 		session[:user_id] = Fabricate(:user).id
	 		video = Fabricate(:video)
	 		get :show, id: video.id
	 		expect(assigns(:video)).to eq(video)
	 	end
 	
		it "redirects to the sign in page with an unautheticated use" do
			video = Fabricate(:video)
			get :show, id: video.id
			expect(response).to redirect_to new_session_path
		end

		it "assigns the @reviews variable for authenticated users" do |variable|
			session[:user_id] = Fabricate(:user).id
	 		video = Fabricate(:video)
	 		review1 = Fabricate(:review, video: video)
	 		review2 = Fabricate(:review, video: video)
	 		get :show, id: video.id
	 		expect(assigns(:reviews)).to match_array [review1, review2]
		end
	end

	describe "POST search" do
		it "assigns the @search results for authenticated users" do
			session[:user_id] = Fabricate(:user).id
			futurama = Fabricate(:video, title: 'futurama')
			post :search, search_term: 'rama'
			expect(assigns(:search_results)).to eq([futurama])			
		end

		it "redirects to sign in page for unautheticated users" do
			futurama = Fabricate(:video, title: 'futurama')
			post :search, search_term: 'rama'
			expect(response).to redirect_to new_session_path
		end
	end
end	
