require 'spec_helper'


describe Category do
	it "saves a valid Category" do
		comedies = Category.new(name: "comedies")
		comedies.save
		expect(Category.first).to eq(comedies)
	end

	it "has many videos" do
		should have_many :videos
	end
end
