require 'spec_helper'

describe StripeWrapper do
	describe StripeWrapper::Charge do
		describe ".create" do
			it "makes a successful charge", vcr: true do 
				Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
				token = Stripe::Token.create( :card => 
					{ :number => "4242424242424242",
					  :exp_month => 1,
					  :exp_year => 2019, 
					  :cvc => "314" 
					}, 
					).id

				response = StripeWrapper::Charge.create(
					amount: 999,
					card: token,
					description: "A successful charge."
					)

				expect(response.amount).to eq(999)
				expect(response.currency).to eq('usd')
			end
		end
	end
end