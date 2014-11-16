require 'spec_helper'

feature "Create new user" do
  scenario "unsuccessfully" do
    visit('/users/new')
    fill_in('Email Address', :with => 'user@example.com' )
    fill_in('Password', :with => "password")
    fill_in('Confirm Password', :with => "password" )
    fill_in('Full Name', :with => "" )
    click_button 'Sign Up'
    expect(page).to have_content("Register")
  end

  scenario "unsuccessfully" do
    visit('/users/new')
    fill_in('Email Address', :with => 'user@example.com' )
    fill_in('Password', :with => "password")
    fill_in('Confirm Password', :with => "password" )
    fill_in('Full Name', :with => "My Name" )
    click_button 'Sign Up'
    expect(page).to have_content("Welcome to MyFlix!")
  end
end
