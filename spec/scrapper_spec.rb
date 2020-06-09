# frozen_string_literal: true

require_relative './../lib/scrapper.rb'
RSpec.describe Scrapper do
  describe '#initialize' do
    let(:scrapper) { Scrapper.new }
    it 'Initializes  the object' do
      expect(scrapper.url).to be_nil
    end
  end

  describe '#setup' do
    let(:scrapper) { Scrapper.new }
    it 'Sets up the scrapper with the given url' do
      expect(scrapper.setup('https://www.buzzfeed.com')).to be_truthy
    end

    it 'raises an error if the URL is not provided' do
      expect { scrapper.setup }.to raise_error(ArgumentError)
    end
  end

  describe '#add_page' do
    let(:scrapper) { Scrapper.new }
    it 'returns true if the page is not in the pages list' do
      scrapper.setup('https://www.buzzfeed.com')
      expect(scrapper.add_page('https://www.buzzfeed.com/buzz')).to be_truthy
    end
    it 'returns false if the page is already in the pages list ' do
      scrapper.setup('https://www.buzzfeed.com/hello')
      expect(scrapper.add_page('https://www.buzzfeed.com/hello')).to be_falsey
    end
  end

  describe '#scrap_page' do
    let(:scrapper) { Scrapper.new }
    it 'returns true if the page content has been scrapped' do
      scrapper.setup('https://www.buzzfeed.com')
      expect(scrapper.scrap_page('https://www.buzzfeed.com')).to be_truthy
    end
    it 'returns false if the page content can not be scrapped' do
      scrapper.setup('https://www.newsweek.com')
      expect(scrapper.scrap_page('https://www.newsweek.com/')).to be_falsey
    end
  end

  describe '#next_page' do
    let(:scrapper) { Scrapper.new }
    it 'returns false if no next page' do
      scrapper.setup('https://www.buzzfeed.com')
      expect(scrapper.next_page).to be_falsey
    end
    it 'returns true if there is a next page' do
      scrapper.setup('https://www.buzzfeed.com')
      scrapper.add_page('https://www.buzzfeed.com/buzz')
      expect(scrapper.next_page).to be_truthy
    end
  end

  describe '#build' do
    let(:scrapper) { Scrapper.new }
    it 'returns a numeric value if the page has been built' do
      scrapper.setup('https://www.buzzfeed.com')
      scrapper.scrap_page('https://www.buzzfeed.com')
      scrapper.selector = 'article.story-card'
      expect(scrapper.build).to be_an(Numeric)
    end

    it 'returns 0 if the page  can\'t be build' do
      scrapper.setup('https://www.buzzfeed.com')
      scrapper.scrap_page('https://www.buzzfeed.com')
      expect(scrapper.build).to eql(0)
    end
  end

  describe '#save_to_file' do
    let(:scrapper) { Scrapper.new }
    it 'returns true if the file name is saved' do
      scrapper.setup('https://www.buzzfeed.com')
      scrapper.scrap_page('https://www.buzzfeed.com')
      scrapper.selector = 'article.story-card'
      expect(scrapper.save_to_file).to eql(true)
    end
  end

  describe '#parsing?' do
    let(:scrapper_x) { Scrapper.new }
    it 'returns false if there are no page to parse' do
      expect(scrapper_x.parsing?).to be_falsey
    end

    it 'returns true if there are  page to parse' do
      scrapper_x.add_page('https://www.buzzfeed.com/buzz')
      scrapper_x.add_page('https://www.buzzfeed.com/celebrity')
      expect(scrapper_x.parsing?).to be_truthy
    end
  end
end
