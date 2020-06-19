FactoryBot.define do
  factory :user do
    email { "test-#{rand(1..300)}@example.com" }
    password { "123456" }
    password_confirmation { "123456" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
