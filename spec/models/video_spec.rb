require 'spec_helper'

describe Video do
  it "has a valid model" do
  	video = Video.create(title: "title", 
  											 description: "description",
  											 small_cover_url: "url",
  											 large_cover_url: "url")
  	expect(video).to be_valid
  end
end
