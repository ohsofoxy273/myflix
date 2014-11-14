require 'spec_helper'

describe User do

	it "is valid with a name and email" do
		user = User.create(name: "Bob", email: "bob@bob.com", password: "foobar", password_confirmation: "foobar")
		expect(user).to be_valid
	end 
	
	it "is invalid without a name" do
		user = User.create(name: "", email: "bob@bob.com", password: "foobar", password_confirmation: "foobar")
		expect(user).not_to be_valid
	end
	
	it "is invalid without an email" do
		user = User.create(name: "Bob", email: "", password: "foobar", password_confirmation: "foobar")
		expect(user).not_to be_valid	
	end
	
	it "enforces the name not being too long" do
		name = "a" * 51
		user = User.create(name: name, email: "bob@bob.com", password: "foobar", password_confirmation: "foobar")
		expect(user).not_to be_valid
	end

	it "enforces the email not being too long" do
		email = "a" * 256
		user = User.create(name: "Bob", email: email, password: "foobar", password_confirmation: "foobar")
		expect(user).not_to be_valid
	end

	it "is valid with a correctly formatted email" do
		valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn] 
    valid_addresses.each do |valid_address|
      user = User.create(name: "Bob_#{valid_address}", email: valid_address, password: "foobar", password_confirmation: "foobar")
      expect(user).to be_valid
    end
  end

	it "is invalid with an incorrectly formatted email" do
		invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      user = User.create(name: "Bob_#{invalid_address}", email: invalid_address, password: "foobar", password_confirmation: "foobar")
      expect(user).to_not be_valid
    end	
	end
	
	it "accepts only unique email addresses" do
		user_1 = User.create(name: "Bob", email: "bob@bob.com", password: "foobar", password_confirmation: "foobar")
		user_2 = User.create(name: "Joe", email: "bob@bob.com", password: "foobar", password_confirmation: "foobar")
		expect(User.all.count).to eq(1)
	end

	it "enforces a minimum password length of 6" do
		user = User.create(name: "Bob", email: "bob@bob.com", password: "fooba", password_confirmation: "fooba")
		expect(user.errors[:password].size).to eq(1)
	end
end
