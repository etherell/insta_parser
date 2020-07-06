class ParseUsersWorker
  require 'json'
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(location_id, number_of_pages)
    Users::ParseService.call(location_id, number_of_pages)
  end
end