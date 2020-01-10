# frozen_string_literal: true

require 'nokogiri'
require 'httparty'
require 'byebug'
require 'json'
require 'date'
# scrapper class
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
    add_page(url)
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
    PAGES[:list].index { |v| v == url }
  end

  def next_page
    if PAGES[:current].nil?
      PAGES[:current] = PAGES[:list][0]
    else
      PAGES[:previous] = @url
      PAGES[:current] = PAGES[:next]
    end

    PAGES[:parsed] << @url
    index = get_index(PAGES[:current])
    PAGES[:next] = PAGES[:list][index + 1]
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

  def build_element(_element)
    {}
  end

  def save_to_file
    return true if File.open("data/#{@filename}", 'w') do |f|
      f.write(JSON.pretty_generate(ELEMENTS))
    end

    false
  end

  def parsing?
    return false if PAGES[:list].count == PAGES[:parsed].count

    true
  end

  def new_element?(url)
    ELEMENTS.none? { |k| k[:link] == url }
  end

  def count?
    ELEMENTS.count
  end
end
