class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :venue, null: false, foreign_key: true
      t.date :booking_date
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
