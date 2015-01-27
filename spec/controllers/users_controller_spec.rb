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
    context "successful user sign up" do
      
    	it "redirects to home path" do
        result = double(:sign_up_result, successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
    		expect(response).to redirect_to home_path
    	end
    end

    context "failed user sign up" do
      it "renders the :new template", vcr: true do
        charge = double(:charge, successful?: false, error_message: "Your card was declined")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1234'
        expect(response).to render_template(:new)
      end

      it "sets the flash error message", vcr: true do
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1234'
        expect(flash[:error]).to eq("Your card was declined.")
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
