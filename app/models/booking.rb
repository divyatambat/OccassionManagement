class Booking < ApplicationRecord

  belongs_to :user
  belongs_to :venue

  validates :user_id, :venue_id, :booking_date, :start_time, :end_time, :status, presence: true

  validate :no_overlapping_bookings

  def no_overlapping_bookings
    if overlapping_bookings.present?
      errors.add(:base, "Booking overlaps with an existing booking")
    end
  end

  def overlapping_bookings
    Booking.where(venue_id: venue_id).where.not(id: id) 
           .where("start_time < ?", end_time)
           .where("end_time > ?", start_time)
  end

  def as_json(options = {})
    super(options.merge(except: [:created_at, :updated_at]))
  end

end
