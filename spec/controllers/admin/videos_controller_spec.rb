require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    it_behaves_like "requires admin" do
      let(:action) { get :new }
    end

    it "sets the @video to a new video" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_instance_of Video
      expect(assigns(:video)).to be_new_record
    end

    it "sets the flash error message for the regular user" do
      set_current_user
      get :new
      expect(flash[:error]).to be_present
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    it_behaves_like "requires admin" do
      let(:action) { get :new }
    end

    context "with valid input" do
      it "redirects to the add new video page" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: "Monty", category_id: category.id, description: "Great stuff"}
        expect(response).to redirect_to new_admin_video_path
      end

      it "creates a video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: "Monty", category_id: category.id, description: "Great stuff"}
        expect(category.videos.count).to eq(1)
      end

      it "sets the flash success message" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: "Monty", category_id: category.id, description: "Great stuff"}
        expect(flash[:success]).to be_present
      end
    end
    context "with invalid input" do 
      it "does not create a video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { category_id: category.id, description: "Great stuff"}
        expect(category.videos.count).to eq(0)
      end

      it "renders the :new template" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { category_id: category.id, description: "Great stuff"}
        expect(response).to render_template :new
      end

      it "set the @video variable" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { category_id: category.id, description: "Great stuff"}
        expect(assigns(:video)).to be_instance_of(Video)
      end

      it "sets the flash error message" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { category_id: category.id, description: "Great stuff"}
        expect(flash[:error]).to be_present
      end
    end
  end
end