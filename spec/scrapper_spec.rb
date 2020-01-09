# frozen_string_literal: true

require_relative './../lib/scrapper.rb'
RSpec.describe Scrapper do
  describe "#initialize" do
    let(:scrapper) { Scrapper.new("https://www.buzzfeed.com") }
    it "Initialize the object" do
      expect(scrapper.url).to eql("https://www.buzzfeed.com")
    end
  end

  
	
end
