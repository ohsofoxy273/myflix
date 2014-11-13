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

  describe "#search_by_title" do

    it "returns [] if search result is empty" do
      search_result = Video.search_by_title("beast")
      expect(search_result).to eq([])
    end

    it "returns the correct list if an exact match is found" do
      video_3 = Video.create(title: "Family Guy", 
                         description: "familial video")
      search_result = Video.search_by_title("Family Guy")
      expect(search_result).to eq([video_3])
    end

    it "returns the correct list of one if a partial match of one is found" do
      video_3 = Video.create(title: "Family Guy", 
                         description: "familial video")
      search_result = Video.search_by_title("fAmIl")
      expect(search_result).to eq([video_3])
    end
    
    it "returns the correct value if multiple videos are found" do 
      video_2 = Video.create(title: "Futurama", 
                         description: "futuristic video")
      video_3 = Video.create(title: "Futuristic Guy", 
                         description: "familial video")
      search_result = Video.search_by_title("futur")
      expect(search_result).to eq([video_2, video_3])
    end

    it "returns an empty array for an empty string" do
      search_result = Video.search_by_title("")
      expect(search_result).to eq([])
    end
  end
end