class User < ApplicationRecord
  validates :username, presence: true
  validates :location, presence: true
  validates_uniqueness_of :username, scope: :location

  self.per_page = 20
end
