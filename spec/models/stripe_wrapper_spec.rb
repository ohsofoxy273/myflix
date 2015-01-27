require 'spec_helper'

describe StripeWrapper do
	describe StripeWrapper::Charge do
		let(:valid_token) do
			Stripe::Token.create( :card => 
					{ :number => "4242424242424242",
					  :exp_month => 1,
					  :exp_year => 2019, 
					  :cvc => "314" 
					}, 
					).id
		end

		let(:declined_card_token) do
			Stripe::Token.create( :card => 
					{ :number => "4000000000000002",
					  :exp_month => 1,
					  :exp_year => 2019, 
					  :cvc => "314" 
					}, 
					).id
		end

		describe ".create" do
			it "makes a successful charge", vcr: true do 

				response = StripeWrapper::Charge.create(
					amount: 999,
					card: valid_token,
					description: "A successful charge."
					)

				expect(response.successful?).to be true
			end

			it "makes a card declined charge", vcr: true do
				
				response = StripeWrapper::Charge.create(
					amount: 999,
					card: declined_card_token,
					description: "An unsuccessful charge."
					)

				expect(response.successful?).to be false
			end

			it "returns the error message for declined charges", vcr: true do
				
				response = StripeWrapper::Charge.create(
					amount: 999,
					card: declined_card_token,
					description: "An unsuccessful charge."
					)

				expect(response.error_message).to eq("Your card was declined.") 			
			end
		end

		describe StripeWrapper::Customer do
			it "creates a customer with a valid charge", vcr: true do
				alice = Fabricate(:user)
				response = StripeWrapper::Customer.create(
					user: alice,
					card: valid_token)
				expect(response).to be_successful
			end

			it "does not create a customer with a declined card", vcr: true do
				alice = Fabricate(:user)
				response = StripeWrapper::Customer.create(
					user: alice,
					card: declined_card_token
					)
				expect(response).not_to be_successful
			end

			it "returns the error message for declined card", vcr: true do
				alice = Fabricate(:user)
				response = StripeWrapper::Customer.create(
					user: alice,
					card: declined_card_token
					)
				expect(response.error_message).to eq("Your card was declined.")
			end

			it "returns the customer token for a valid card", vcr: true do
				alice = Fabricate(:user)
				response = StripeWrapper::Customer.create(
					user: alice,
					card: valid_token)
				expect(response.customer_token).to be_present
			end
		end
	end
end