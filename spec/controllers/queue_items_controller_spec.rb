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

  describe "DELETE destroy" do
    it "redirects to the my queue page" do
      session[:user_id] = Fabricate(:user).id
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to(my_queue_path)
    end
    
    it "deletes the queue item" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item = Fabricate(:queue_item, user: user)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end
    
    it "does not delete the queue item if the current user does not own the queue item" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      session[:user_id] = alice.id
      queue_item = Fabricate(:queue_item, user: bob)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end

    it "redirects to the sign in page for unauthenticated users"  do
      delete :destroy, id: 3
      expect(response).to redirect_to new_session_path
    end

    it "normalizes the remaining queue items" do
      alice = Fabricate(:user)
      session[:user_id]  = alice.id
      queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
      queue_item2 = Fabricate(:queue_item, user: alice, position: 2)
      delete :destroy, id: queue_item1.id
      expect(QueueItem.first.position).to eq(1)
    end
  end

  describe "POST update_queue" do
    context "with valid inputs" do
      it "redirects to the my_queue page" do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to(my_queue_path)
      end

      it "reorders the que_items" do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(alice.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the position numbers" do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(alice.queue_items.map(&:position)).to eq([1,2])
      end
    end
    context "with invalid inputs" do
      it "redirects to the queue items page" do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.4}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to(my_queue_path)
      end

      it "sets the flash error message" do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.4}, {id: queue_item2.id, position: 1}]
        expect(flash[:error]).to be_present
      end
      
      it "does not change the queue items" do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "with unauthenticated users" do
      it "redirects to the sign in path" do
        post :update_queue, queue_items: [{id: 1, position: 3}, {id: 2, position: 1}]
        expect(response).to redirect_to(new_session_path)
      end
    end

    context "with queue items that do not belong to the current user" do
      it "does not change the queue items" do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        session[:user_id] = alice.id
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: bob, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end