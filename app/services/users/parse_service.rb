# frozen_string_literal: true

module Users
  require 'json'

  class ParseService < ApplicationService
    attr_reader :location_id, :number_of_pages
    attr_accessor :location, :end_cursor, :usernames

    def initialize(location_id, number_of_pages)
      @location_id = location_id
      @number_of_pages = number_of_pages.to_i
      @location = ''
      @end_cursor = nil
      @usernames = []
    end

    def call
      set_location
      set_usernames
      create_users
    end

    private

    def set_location
      url = "https://www.instagram.com/explore/locations/#{location_id}/?__a=1"
      json = parse_page(url)
      self.location = json['graphql']['location']['name']
    end

    def set_usernames
      json_array = []
      post_urls = []
      fill_json_array(json_array)

      json_array.each do |json|
        posts = json['graphql']['location']['edge_location_to_media']['edges']
        fill_posts_urls_array(posts, post_urls)
        fill_users_array(post_urls)
      end
    end

    def create_users
      usernames.uniq.each do |username|
        User.create(username: username, location: location)
      end
    end

    def fill_json_array(json_array)
      number_of_pages.times do
        url = "https://www.instagram.com/explore/locations/#{location_id}/?__a=1&max_id=#{end_cursor}"
        json = parse_page(url)
        self.end_cursor = json['graphql']['location']['edge_location_to_media']['page_info']['end_cursor']
        json_array << json
      end
    end

    def fill_posts_urls_array(posts, post_urls)
      posts.each do |post|
        url_part = post['node']['shortcode']
        url = "https://www.instagram.com/p/#{url_part}/?__a=1"
        post_urls << url
      end
    end

    def fill_users_array(post_urls)
      post_urls.each do |post_url|
        post_json = parse_page(post_url)
        username = post_json['graphql']['shortcode_media']['owner']['username']
        usernames << username
      end
    end

    def parse_page(url)
      response = HTTParty.get(url)
      JSON.parse(response.body)
    end
  end
end
