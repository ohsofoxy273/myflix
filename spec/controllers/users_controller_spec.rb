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

      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joe@example.com")
        post :create, user: { email: "joe@example.com", password: "password", name: "Joe Doe" }, invitation_token: invitation.token
        joe = User.where(email: "joe@example.com").first
        expect(joe.follows?(alice)).to be true
      end

      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joe@example.com")
        post :create, user: { email: "joe@example.com", password: "password", name: "Joe Doe" }, invitation_token: invitation.token
        joe = User.where(email: "joe@example.com").first
        expect(alice.follows?(joe)).to be true
      end

      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joe@example.com")
        post :create, user: { email: "joe@example.com", password: "password", name: "Joe Doe" }, invitation_token: invitation.token
        expect(Invitation.first.token).to be_nil
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
  
    context "sending emails" do

      after { ActionMailer::Base.deliveries.clear }
      
      it "sends out email to the user with valid inputs" do
        post :create, user: { email: "joe@example.com", password: "password", name: "Joe Smith"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end

      it "sends out email containing the user's name wiht valid inputs" do
        post :create, user: { email: "joe@example.com", password: "password", name: "Joe Smith"}
        expect(ActionMailer::Base.deliveries.last.body).to include("Joe Smith")
      end

      it "does not send out email with invalid inputs" do
        post :create, user: { email: "joe@example.com" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 3 }
    end

    it "sets @user" do
      set_current_user
      alice = Fabricate(:user)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end
  end

  describe "GET new_with_invitation_token" do
    it "renders the :new view template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new 
    end

    it "sets @user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email) 
    end
    
    it "sets @invitation_token with invitation token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token) 
    end

    it "redirects to invalid token page for invalid tokens" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: "invalid_token"
      expect(response).to redirect_to expired_token_path 
    end
  end
end
