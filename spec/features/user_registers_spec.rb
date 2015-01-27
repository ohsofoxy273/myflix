require 'spec_helper'

feature 'User registers', { js: true, vcr: true } do
  background do
    visit new_user_path
  end

  scenario "with valid user info and valid card" do
    fill_in_valid_user_info
    fill_in_valid_card
    click_button "Sign Up"
    expect(page).to have_content("Welcome to MyFlix!")
  end

  scenario "with valid user info and invalid card" do
    fill_in_valid_user_info
    fill_in_invalid_card
    click_button "Sign Up"
    expect(page).to have_content("This card number looks invalid")
  end
  
  scenario "with valid user info and declined card" do
    fill_in_valid_user_info
    fill_in_declined_card
    click_button "Sign Up"
    expect(page).to have_content("Your card was declined.")
  end
  
  scenario "with invalid user info and valid card" do
    fill_in_invalid_user_info
    fill_in_valid_card
    click_button "Sign Up"
    expect(User.count).to eq(0) 
  end

  scenario "with invalid user info and invalid card" do
    fill_in_invalid_user_info
    fill_in_invalid_card
    click_button "Sign Up"
    expect(User.count).to eq(0)
  end
  
  scenario "with invalid user info and declined card" do
    fill_in_invalid_user_info
    fill_in_declined_card
    click_button "Sign Up"
    expect(User.count).to eq(0)
  end

  def fill_in_valid_user_info
    fill_in "Email Address", with: "john@example.com"
    fill_in "Password", with: "123456"
    fill_in "Confirm Password", with: "123456"
    fill_in "Full Name", with: "John Doe"
  end

  def fill_in_invalid_user_info
    fill_in "Email Address", with: "john"
    fill_in "Password", with: "123456"
    fill_in "Full Name", with: "John Doe"
  end

  def fill_in_valid_card 
    fill_in "Credit Card Number", with: ("42"*8)
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "2019", from: "date_year"
  end

  def fill_in_invalid_card
    fill_in "Credit Card Number", with: "123"
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "2019", from: "date_year"
  end

  def fill_in_declined_card
    fill_in "Credit Card Number", with: ("4" + "0"*14 + "2")
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "2019", from: "date_year"
  end
end