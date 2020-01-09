require_relative './scrapper'
class Buzzfeed < Scrapper

    def initialize(url)
      @url = url
      add_page(@url)
      @filename = "buzzfeed.json"
      @selector = "article.story-card"      
      @categories= ["Buzz","Celebrity","Community","Entertainment","Food","Life","Music","Nifty","Parents"]      
      
      @categories.each do |x|
        url = "#{@url}#{x.downcase}"
        add_page(url)
      end
      load_file
    end
  
    def build_element(element)
      {
          title: element.css('a.js-card__link').text,
          link: element.css('a')[0].attributes['href'].value,
          excerpt: element.css('p.js-card__description').text,
          cover: element.css('.card__image img').attr("src"),
          source: "https://www.buzzfeed.com",
          scraped_at: DateTime.now() 
        }
    end
  end