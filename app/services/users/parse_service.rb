module Users
  class ParseService < ApplicationService
    require 'open-uri'
    require 'json'

    attr_reader :location_id, :number_of_pages, :end_cursor, :post_urls

    def initialize(location_id, number_of_pages)
      @location_id = location_id
      @number_of_pages = number_of_pages.to_i
      @end_cursor = ""
      @post_urls = []
    end

    def call
      parse_users
    end

    private

    def parse_users
      number_of_pages.times do
        url = "https://www.instagram.com/explore/locations/#{location_id}/?__a=1&max_id=#{end_cursor}"
        document = Nokogiri::HTML(open(url))
        json = JSON.parse(document)
        posts = json["graphql"]["location"]["edge_location_to_media"]["edges"]
        end_cursor = json["graphql"]["location"]["edge_location_to_media"]["page_info"]["end_cursor"]
        location = json["graphql"]["location"]["name"]

        # Gets links
        posts.each do |post|
          url_part = post["node"]["shortcode"]
          url = "https://www.instagram.com/p/#{url_part}/?__a=1"
          post_urls << url
        end
      
        # Creates users
        post_urls.each do |post_url|
          post_page = Nokogiri::HTML(open(post_url))
          post_json = JSON.parse(post_page)
          username = post_json["graphql"]["shortcode_media"]["owner"]["username"]
          User.create(username: username, location: location)
        end
        
        sleep 2
      end      
    end

  end
end