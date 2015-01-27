require 'spec_helper'

describe "deactivate user on failed charge", vcr: true do
  let(:event_data) do
{
  "id"=> "evt_15OuC5KLRmBJ86oUdAgvJyff",
  "created"=> 1422206945,
  "livemode"=> false,
  "type"=> "charge.failed",
  "data"=> {
    "object"=> {
      "id"=> "ch_15OuC5KLRmBJ86oUheUhiiHL",
      "object"=> "charge",
      "created"=> 1422206945,
      "livemode"=> false,
      "paid"=> false,
      "amount"=> 999,
      "currency"=> "usd",
      "refunded"=> false,
      "captured"=> false,
      "card"=> {
        "id"=> "card_15Ou7uKLRmBJ86oUncNblReI",
        "object"=> "card",
        "last4"=> "0341",
        "brand"=> "Visa",
        "funding"=> "credit",
        "exp_month"=> 1,
        "exp_year"=> 2016,
        "fingerprint"=> "CxG01ehsOeG5mOyv",
        "country"=> "US",
        "name"=> nil,
        "address_line1"=> nil,
        "address_line2"=> nil,
        "address_city"=> nil,
        "address_state"=> nil,
        "address_zip"=> nil,
        "address_country"=> nil,
        "cvc_check"=> "pass",
        "address_line1_check"=> nil,
        "address_zip_check"=> nil,
        "dynamic_last4"=> nil,
        "customer"=> "cus_5YKG3Q4GQYrKFg"
      },
      "balance_transaction"=> nil,
      "failure_message"=> "Your card was declined.",
      "failure_code"=> "card_declined",
      "amount_refunded"=> 0,
      "customer"=> "cus_5YKG3Q4GQYrKFg",
      "invoice"=> nil,
      "description"=> "payment to fail",
      "dispute"=> nil,
      "metadata"=> {},
      "statement_descriptor"=> nil,
      "fraud_details"=> {},
      "receipt_email"=> nil,
      "receipt_number"=> nil,
      "shipping"=> nil,
      "refunds"=> {
        "object"=> "list",
        "total_count"=> 0,
        "has_more"=> false,
        "url"=> "/v1/charges/ch_15OuC5KLRmBJ86oUheUhiiHL/refunds",
        "data"=> []
      }
    }
  },
  "object"=> "event",
  "pending_webhooks"=> 1,
  "request"=> "iar_5a4KqyMQvNbtzr",
  "api_version"=> "2014-12-22"
}
  end

  it "deactivates a user with the web hook data from stripe for charge failed" do
  	alice = Fabricate(:user, customer_token: "cus_5YKG3Q4GQYrKFg")
  	post "/stripe", event_data
  	expect(alice.reload).not_to be_active
  end  

end