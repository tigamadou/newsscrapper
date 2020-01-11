# frozen_string_literal: true

require 'nokogiri'
require 'httparty'
require 'byebug'
require 'json'
require 'date'
# scrapper class
class Scrapper
  attr_accessor :url, :filename, :scraping, :parsing, :selector
  attr_reader :count, :elements
  
  

  def initialize
    @url = nil
    @filename = nil
    @selector = nil
    @parsing = true
    @pages = {
      list: [],
      parsed: [],
      current: nil,
      previous: nil,
      next: nil,
      total: nil
    }
    @pages_list = []
    @pages_parsed=[]
    @page_current=nil
    @@page_previous=nil
    @page_next=nil
    @page_total=nil
    @elements = []
  end

  private

  def new_element?(url)
    @elements.none? { |k| k[:link] == url }
  end

  def build_element(_element)
    {}
  end

  public

  def set_up(url)
    @url =url
    add_page(@url)
    @filename = 'default.json'
    @selector = '.default-selector'
    true
  end

  def add_page(url)
    
    return false if @pages_list.include?(url)

    @pages_list << url
    true
  end

  def filename?
    return @filename unless @filename.nil?

    false
  end

  def scrap_page(url)
    request = HTTParty.get(url)
    if request.code == 200
      @data = Nokogiri::HTML(request)
      return true
    end

    false
  end

  def get_index(url)
    @pages_list.index { |v| v == url }
  end

  def next_page
    if @pages_list.nil?
      @url = @pages_list[0]         
    end
    @pages_parsed<< @url    
    index = get_index(@url)    
    @page_next = @pages_list[index + 1]
    @page_previous = @url
    @url = @page_next
    
    return true unless @page_next.nil?

    false
  end

  def build
    @list = @data.css(@selector)
    @count = @list.count
    @list.each do |article|
      element = build_element(article)
      @elements << element if new_element?(element[:link])
    end
    @list.count
    
  end

  

  def save_to_file
    
    return true if File.open("data/#{@filename}", 'w') do |f|
      f.write(JSON.pretty_generate(@elements))
    end

    false
  end

  def parsing?
    
    return false if @pages_list.count == @pages_parsed.count
    
    true
  end

  

  def count?
    @elements.count
  end
end
