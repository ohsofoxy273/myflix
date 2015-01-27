require 'spec_helper'

describe "Create payment on successful charge", vcr: true do
  let(:event_data) do
    {
      "id" => "evt_103rpP27wYrAQOnHaM5w2erQ",
      "created" => 1397703584,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_103rpP27wYrAQOnHV9wI5USC",
          "object" => "charge",
          "created" => 1397703584,
          "livemode" => false,
          "paid" => true,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_103rpP27wYrAQOnHGtVqKqtK",
            "object" => "card",
            "last4" => "4242",
            "type" => "Visa",
            "exp_month" => 4,
            "exp_year" => 2017,
            "fingerprint" => "v5aIbtpRE6eDf9H7",
            "customer" => "cus_3rpPs9u5lEgj71",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil
          },
          "captured" => true,
          "refunds" => [

          ],
          "balance_transaction" => "txn_103rpP27wYrAQOnHwr8RYbmo",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_3rpPs9u5lEgj71",
          "invoice" => "in_103rpP27wYrAQOnHLtgNIGIE",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {
          },
          "statement_description" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_3rpPtXGAnEa28N"
    }
  end

  it "creates a payment with the webhook from stripe for charge succeeded" do 
    post "/stripe", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user" do
    alice = Fabricate(:user, customer_token: "cus_3rpPs9u5lEgj71")
    post "/stripe", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates the payment with the amount" do
    alice = Fabricate(:user, customer_token: "cus_3rpPs9u5lEgj71")
    post "/stripe", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference id" do
    alice = Fabricate(:user, customer_token: "cus_3rpPs9u5lEgj71")
    post "/stripe", event_data
    expect(Payment.first.reference_id).to eq("ch_103rpP27wYrAQOnHV9wI5USC")
  end  

end