FactoryBot.define do
  factory :booking do
    association :user
    association :venue
    booking_date { Faker::Date.forward(days: 5) }
    start_time { Faker::Time.forward(days: 5, period: :morning) }
    end_time { Faker::Time.forward(days: 5, period: :evening) }
    status { ['booked', 'cancelled'].sample } # Randomly select a status from available options
  end
end
