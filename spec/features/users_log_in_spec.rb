require 'spec_helper'

feature "Log in user" do
  scenario "successfully" do
    user = User.create(name: "Bob", email: "bob@bob.com", password: "foobar", password_confirmation: "foobar")
    visit('/sessions/new')
    fill_in('Email Address', :with => user.email )
    fill_in('Password', :with => user.password)
    click_button 'Sign in'
    expect(page).not_to have_content("Sign in")
  end

  scenario "unsuccessfully" do
    visit('/sessions/new')
    fill_in('Email Address', :with => 'user@example.com' )
    fill_in('Password', :with => "")
    click_button 'Sign in'
    expect(page).to have_content("Sign in")
  end
end