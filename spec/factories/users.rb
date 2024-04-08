FactoryBot.define do
  factory :user do
    transient do
      role_name { User::DEFAULT_ROLE_NAME }
    end

    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    before(:create) do |user, evaluator|
      user.role = Role.find_or_create_by(name: evaluator.role_name)
    end
  end
end
