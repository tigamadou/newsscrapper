# frozen_string_literal: true

require_relative './../lib/scrapper.rb'
RSpec.describe Scrapper do
  describe "#initialize" do
    let(:scrapper) { Scrapper.new("https://www.buzzfeed.com") }
    it "Initialize the object" do
      expect(scrapper.url).to eql("https://www.buzzfeed.com")
    end
	end
	
	describe "#add_page" do
    let(:scrapper) { Scrapper.new("https://www.buzzfeed.com") }
    it "return true if the page is not in the list yed and add it to the list" do
      expect(scrapper.add_page("https://www.buzzfeed.com/buzz")).to be_truthy
    end
    it "return false if the page is already in the list yed and add it to the list" do
      expect(scrapper.add_page("https://www.buzzfeed.com/buzz")).to be_falsey
    end
  end

  

  
	
end
