require 'spec_helper'

describe Video do
  video = Video.create(title: "title", 
  											 description: "description",
  											 small_cover_url: "url",
  											 large_cover_url: "url")
  it "has a valid model" do
  	expect(video).to be_valid
  end

  it "belongs to categories" do
  	should belong_to :category
  end

  it "validates the presence of 'title" do
    should validate_presence_of :title
  end

  it "validates the presence of 'description" do
    should validate_presence_of :description
  end
end
