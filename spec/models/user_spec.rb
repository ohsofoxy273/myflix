require 'spec_helper'

describe User do
	it { should have_many(:queue_items).order(:position) }
	it { should have_many(:reviews).order("created_at DESC")}

	it_behaves_like "tokenable" do
		let(:object) {Fabricate(:user)}
	end

	let(:user) { User.create(name: "Bob", email: "bob@bob.com", password: "foobar", password_confirmation: "foobar") }
	it "is valid with a name and email" do
		expect(user).to be_valid
	end 
	
	it "is invalid without a name" do
		user.name = ""	
		expect(user).not_to be_valid
	end
	
	it "is invalid without an email" do
		user.email = ""	
		expect(user).not_to be_valid	
	end
	
	it "enforces the name not being too long" do
		name = "a" * 51
		user.name = name	
		expect(user).not_to be_valid
	end

	it "enforces the email not being too long" do
		email = "a" * 256
		user.email = email	
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
		user_1 = user
		user_2 = user 
		expect(User.all.count).to eq(1)
	end

	it "enforces a minimum password length of 6" do
		user = User.create(name: "Bob", email: "bob@bob.com", password: "fooba", password_confirmation: "fooba")
		expect(user.errors[:password].size).to eq(1)
	end

	describe "#queued_video?" do
		it "returns true if the video is present in the queue" do
			user = Fabricate(:user)
			video = Fabricate(:video)
			Fabricate(:queue_item, video: video, user: user)
			expect(user.queued_video?(video)).to be true
		end

		it "returns false if the video is not present in the queue" do
			user = Fabricate(:user)
			video = Fabricate(:video)
			expect(user.queued_video?(video)).to be false
		end
	end

	describe "#follows?" do
		it "returns true if the user has a following relationship with another user" do
			alice = Fabricate(:user)
			bob = Fabricate(:user)
			Fabricate(:relationship, leader: bob, follower: alice)
			expect(alice.follows?(bob)).to be true
		end
		
		it "returns false of the the user does not have a following relationship wiht another user" do
			alice = Fabricate(:user)
			bob = Fabricate(:user)
			mike = Fabricate(:user)
			Fabricate(:relationship, leader: mike, follower: alice)
			expect(alice.follows?(bob)).to be false
		end
	end

	describe "#follow" do
		it "follows another user" do
			alice = Fabricate(:user)
			bob = Fabricate(:user)
			alice.follow(bob)
			expect(alice.follows?(bob)).to be true
		end

		it "does not follow oneself" do
			alice = Fabricate(:user)
			alice.follow(alice)
			expect(alice.follows?(alice)).to be false
		end
	end

	describe "#deactivate!" do
		it "deactivates an active user" do
			alice = Fabricate(:user, active: true)
			alice.deactivate!
			expect(alice.reload).not_to be_active
		end
	end
end
