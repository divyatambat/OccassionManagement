
FactoryBot.define do
  factory :role do
    name { Faker::Lorem.word.capitalize }
  end
end
