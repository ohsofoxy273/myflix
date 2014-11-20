require 'spec_helper'

describe UsersController do

  describe "GET 'new'" do
    it "returns http success" do
      get :new
      response.should be_success
    end
    
    it "sets the @user variable" do
    	get :new
    	expect(assigns(:user)).to be_instance_of(User)
    end

    it "renders the 'new' template" do
    	get :new
    	expect(response).to render_template :new
    end
  end

  describe "POST create" do
    context "for valid users" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end 

    	it "creaates the user record" do
    		expect(User.count).to eq(1)
    	end

    	it "redirects to home path" do
    		post :create, user: Fabricate.attributes_for(:user)
    		expect(response).to redirect_to home_path
    	end
    end

    context "for invalid users" do
    	before do
        post :create, :user => {user: { email: "user@example.com", name: "Joe", password: "password" }}
      end
      it "does not create the user record" do 
    		expect(User.count).to eq(0)
    	end

    	it "renders 'new' template" do
    		expect(response).to render_template :new			
    	end

    	it "sets the @user variable" do
    		expect(assigns(:user)).to be_instance_of(User)
    	end
    end
  end
end
