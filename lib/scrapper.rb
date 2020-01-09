require "nokogiri"
require 'httparty'
require 'byebug'
require 'uri'
require 'json'
require 'date'

class Scrapper
  attr_accessor :url, :filename, :PAGES, :scraping, :parsing, :new_elements
  attr_reader :count, :elements
  PAGES = {
    list: Array.new,
    parsed: Array.new,
    current: nil,
    previous: nil,
    next: nil,
    total: nil
  }
  ELEMENTS = []

  @filename = 'default.json'
  @selector = ''
  @parsing = true
  def initialize(url)
    @url = url
    @new_elements = 0
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

    else
      PAGES[:previous] = @url
      PAGES[:current] = PAGES[:next]

    end
    PAGES[:parsed] << @url
    PAGES[:next] = PAGES[:list][(PAGES[:list].index(PAGES[:current])) + 1]
    @url = PAGES[:current]
    puts @url = PAGES[:current]
  end

  def build
    list = @data.css(@selector)
    @count = list.count
    list.each do |article|
      element = build_element(article)
      if is_new_element?(element[:link])
        ELEMENTS << element

      end
    end
  end

  def build_element(element)
    {}
  end

  def save_to_file
    File.open("data/#{@filename}", "w") do |f|
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

  def is_new_element?(url)
    !ELEMENTS.any? { |k| k[:link] == url }
  end

  def get_count
    return ELEMENTS.count
  end
end
