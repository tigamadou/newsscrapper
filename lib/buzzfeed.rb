require_relative './scrapper'
class Buzzfeed < Scrapper
    def initialize(search_query=nil)
      @url = "https://www.buzzfeed.com/"
      @filename = "buzzfeed.json"
      @selector = "article.story-card"      
      @pages= ["Buzz","Celebrity","Community","Entertainment","Food","Life","Music","Nifty","Parents"]      
      
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