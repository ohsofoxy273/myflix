require 'spec_helper'

describe Review do
  it "passes with valid input" do
  	review = Review.create(rating: 4, content: Faker::Lorem.paragraph)
  	expect(review).to be_valid
  end

  it {should belong_to :video}
  it {should belong_to :user}

  it "requires rating to be present" do
  	review = Review.create(rating: nil, content: Faker::Lorem.paragraph)
  	expect(review).to be_invalid
  end

  it "requires content to be present" do
  	review = Review.create(rating: 3, content: nil)
  	expect(review).to be_invalid
  end

  it "accepts a rating no less than 1" do
  	review = Review.create(rating: 0, content: Faker::Lorem.paragraph)
  	expect(review).to_not be_valid
  end
  
  it "accepts a rating no greater than 5" do
  	review = Review.create(rating: 6, content: Faker::Lorem.paragraph)
  	expect(review).to_not be_valid
  end

  it "requires the content to be longer than 6 characters" do
  	review = Review.create(rating: 5, content: "a"*5)
  	expect(review).to_not be_valid
  end
end
