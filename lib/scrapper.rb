require "nokogiri"
require 'httparty'
require 'byebug'
require 'uri'
require 'json'
require 'date'

class Scrapper
  attr_accessor :request,:yahoo,:url
  def initialize(search_query=nil)
    @search_query = search_query.to_s if !search_query.nil?
    @filename = "default.json"
    @selector=""
    @ressource = {}    
    @params = {}    
  end

  def search(search_query = nil)
    @search_query = search_query if !search_query.nil?
    @search_query = @search_query.gsub(" ", "+")
    @search_query = URI.encode(@search_query)
    @url = "#{@base_url}search/site/#{@search_query}"
    #@params.each do |k,v|
    #  @url += "&#{k}=#{v}"
    #end    
  end
  def get_url
    @url
  end
  def get_count
    @count
  end
  def get_filename
    @filename
  end
  def scrap_all(url)    
    @data = Nokogiri::HTML(HTTParty.get(url))   
  end

  def build
    @elements = Array.new
    list =@data.css(@selector)
    @count = list.count
    list.each do |article|
      element = build_element(article)      
      @elements << element      
    end
    
    save_to_file
    #byebug
  end

  def build_element(element)
    {
        
      }
  end

  def save_to_file
    File.open("data/#{@filename}","w") do |f|
      f.write(JSON.pretty_generate(@elements))
    end
  end

end

class Buzzfeed < Scrapper
  def initialize(search_query=nil)
    @url = "https://www.buzzfeed.com/"
    @filename = "buzzfeed.json"
    @selector = "article.story-card"
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