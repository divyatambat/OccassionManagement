FactoryBot.define do
  factory :venue do
    name { Faker::Company.name }
    venue_type { Faker::Lorem.word.capitalize }
    start_time { Faker::Time.forward(days: 5, period: :morning) }
    end_time { Faker::Time.forward(days: 5, period: :evening) }
  end
end
