# frozen_string_literal: true

require 'nokogiri'
require 'httparty'
require 'byebug'
require 'json'
require 'date'

class Scrapper
  attr_accessor :url, :filename, :PAGES, :scraping, :parsing, :new_elements, :selector
  attr_reader :count, :elements
  PAGES = {
    list: [],
    parsed: [],
    current: nil,
    previous: nil,
    next: nil,
    total: nil
  }
  ELEMENTS = []

  def initialize(url)
    @url = url
    @new_elements = 0
    @filename = 'default.json'
    @selector = '.default-selector'
    @parsing = true
  end

  def add_page(url)
    return false if PAGES[:list].include?(url)

    PAGES[:list] << url
    true
  end

  def get_filename
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

  def next_page
    if PAGES[:current].nil?
      PAGES[:current] = PAGES[:list][0]
    else
      PAGES[:previous] = @url
      PAGES[:current] = PAGES[:next]

    end
    PAGES[:parsed] << @url
    PAGES[:next] = PAGES[:list][PAGES[:list].index(PAGES[:current]) + 1]
    @url = PAGES[:current]

    return true unless PAGES[:next].nil?

    false
  end

  def build
    @list = @data.css(@selector)
    @count = @list.count
    @list.each do |article|
      element = build_element(article)
      ELEMENTS << element if new_element?(element[:link])
        
      
    end
    @list.count
  end

  def build_element(element)
    {}
  end

  def save_to_file
    return true if File.open("data/#{@filename}", "w") do |f|
      f.write(JSON.pretty_generate(ELEMENTS))
    end

    false
  end

  def parsing?
    return false if PAGES[:list].count == PAGES[:parsed].count

    true
  end

  def new_element?(url)
    !ELEMENTS.any? { |k| k[:link] == url }
  end

  def get_count
    return ELEMENTS.count
  end
end
