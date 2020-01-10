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

  describe "#get_filename" do
    let(:scrapper) { Scrapper.new("https://www.buzzfeed.com") }
    it "return the file name to save the scraped data" do
      expect(scrapper.get_filename).to eql("default.json")
    end

    it "return false if filename is nil" do
      scrapper.filename = nil
      expect(scrapper.get_filename).to be_falsey
    end
  end

  describe "#scrap_page" do
    let(:scrapper) { Scrapper.new("https://www.buzzfeed.com") }
    it "return true if the page content has been scrapped" do
      expect(scrapper.scrap_page("https://www.buzzfeed.com")).to be_truthy
    end
    it "return false if the page content can not be scrapped" do
      expect(scrapper.scrap_page("https://www.newsweek.com/")).to be_falsey
    end
  end

  describe "#next_page" do
    let(:scrapper) { Scrapper.new("https://www.buzzfeed.com") }
    it "return false if the first page is not set " do
      expect(scrapper.next_page).to be_falsey
    end
  end

  describe "#build" do
    let(:scrapper) { Scrapper.new("https://www.buzzfeed.com") }
    it "return numéric if the page has been build" do
      scrapper.scrap_page("https://www.buzzfeed.com")
      scrapper.selector = "article.story-card"
      expect(scrapper.build).to be_an(Numeric)
    end

    it "return 0 if the page has can't be build" do
      scrapper.scrap_page("https://www.buzzfeed.com")
      expect(scrapper.build).to eql(0)
    end
  end

  describe "#save_to_file" do
    let(:scrapper) { Scrapper.new("https://www.buzzfeed.com") }
    it "return true if the file name is saved " do
      scrapper.scrap_page("https://www.buzzfeed.com")
      scrapper.selector = "article.story-card"
      expect(scrapper.save_to_file).to eql(true)
    end
  end

  describe "#is_parsing?" do
    let(:scrapper) { Scrapper.new("https://www.buzzfeed.com") }
    it "return false if there are no page to parse" do
      expect(scrapper.is_parsing?).to be_falsey
    end
    it "return true if there are  page to parse" do
      scrapper.add_page("https://www.buzzfeed.com/buzz")
      scrapper.add_page("https://www.buzzfeed.com/celebrity")
      expect(scrapper.is_parsing?).to be_truthy
    end
  end
end
