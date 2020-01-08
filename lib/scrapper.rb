require "nokogiri"
require 'httparty'
require 'byebug'
require 'uri'

class Scrapper
  attr_accessor :request
	@auth = {:username => "genzaraky@gmail.com",:password=> "5uDADmMcFnY6UL7"}
  def initialize(search_query)
    @search_query = search_query.to_s
    @request = {}
    @request[:base_url] = "https://www.aliexpress.com/wholesale?"
    @request[:pagination] = {
      current: 1,
      first: 1,
      last: nil,
      total: nil
    }
    @params = {}
    search
  end

  def search(search_query = nil)
    @search_query = search_query if !search_query.nil?
    @search_query = @search_query.gsub(" ", "+")
    @search_query = URI.encode(@search_query)
    @request[:url] = @request[:base_url] + @search_query
    @params.each do |k,v|
      @request[:url] += "&#{k}=#{v}"
    end
    get_info
  end

  def get_info
    @request[:data] = Nokogiri::HTML(HTTParty.get(@request[:url]))
    byebug
  end
end
