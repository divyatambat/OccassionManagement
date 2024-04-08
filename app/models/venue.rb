class Venue < ApplicationRecord
  has_many :bookings
  validates :name, presence: true
  validates :venue_type, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  def as_json(options = {})
    super(options.merge(except: [:created_at, :updated_at]))
  end
end
