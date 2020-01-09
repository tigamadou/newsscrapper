require "nokogiri"
require 'httparty'
require 'byebug'
require 'uri'
require 'json'
require 'date'

class Scrapper
  attr_accessor :url, :filename, :PAGES, :scraping, :parsing, :elements
  attr_reader :count
  PAGES = {
    list: Array.new,
    parsed: Array.new,
    current: nil,
    previous: nil,
    next:nil,
    total: nil
  }
  ELEMENTS= Array.new
  def initialize(url)
    @url = url
    add_page(@url)
    @filename = "default.json"
    @selector = ""
    @parsing = true
    load_file
  end

  def load_file
    @file = File.open("data/#{@filename}","a+")
    @elements = JSON.load @file
    print @elements
    byebug
  end

  def close_file
    @file.close
  end

  def is_new_element?(url)
  end
   

  def add_page(url)
    PAGES[:list] << url
  end

  def get_filename
    @filename
  end

  def scrap_page(url)
    @data = Nokogiri::HTML(HTTParty.get(url))
  end

  def next_page
    if PAGES[:current].nil?
      PAGES[:current] = PAGES[:list][0]
      
    elsif
      PAGES[:previous]= @url
      PAGES[:current] = PAGES[:next]
      
    
    end
    PAGES[:parsed] << @url
    PAGES[:next] = PAGES[:list][(PAGES[:list].index(PAGES[:current]))+1]
    @url = PAGES[:current]
    puts @url = PAGES[:current]
    
  end

  def build
    
    list =@data.css(@selector)
    @count = list.count
    list.each do |article|
      element = build_element(article)      
      ELEMENTS << element      
    end  
  end

  def build_element(element)
    {}
  end

  def save_to_file
    @file.each do |f|
      f.write(JSON.pretty_generate(ELEMENTS))
    end
  end

  def is_parsing?
    return false if PAGES[:list].count == PAGES[:parsed].count
    true
  end

  def is_next_page?
    @parsing = false if PAGES[:list].count == PAGES[:parsed].count
  end

  def get_count
    return ELEMENTS.count
  end
end

