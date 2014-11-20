require 'spec_helper'

describe SessionsController do
	describe "GET new" do
		it "renders the new template for unauthenticated users" do
			get :new
			expect(response).to render_template :new
		end
		it "redirects to the home_path for authenticated users" do
			session[:user_id] = Fabricate(:user).id
			get :new
			expect(response).to redirect_to home_path
		end
	end

	describe "POST create" do
		context "with valid credentials" do
			it "puts the signed in user in the session" do
				alice = Fabricate(:user)
				post :create, {session: { email: alice.email, password: alice.password }}
				expect(session[:user_id]).to eq(alice.id)
			end
			it "redirects to the home_path" do
				alice = Fabricate(:user)
				post :create, {session: { email: alice.email, password: alice.password }}
				expect(response).to redirect_to home_path
			end

			it "sets the notice" do
				alice = Fabricate(:user)
				post :create, {session: { email: alice.email, password: alice.password }}
				expect(flash[:notice]).to eq("You are signed in!")
			end
		end

		context "with invalid credentials" do
			it "does not put the signed in user in the session" do
				alice = Fabricate(:user)
				post :create, {session: { email: alice.email, password: alice.password + "j" }}
				expect(session[:user_id]).to be_nil
			end

			it "renders the new template" do
				alice = Fabricate(:user)
				post :create, {session: { email: alice.email, password: alice.password + "j" }}
				expect(response).to render_template :new
			end
		end
	end
	
	describe "GET destroy" do
		before do
			session[:user_id] = Fabricate(:user).id
			get :destroy
		end
		it "clears the session for the user" do
			expect(session[:user_id]).to be_nil
		end

		it "redirects to the root path" do
			expect(response).to redirect_to root_path
		end

		it "sets the notice" do
			expect(flash[:notice]).to eq("You are signed out.")
		end	
	end
end
