FactoryBot.define do
  factory :message do
    content { "Je fais un dépot" }
    sender_full_name { "#{Faker::Name.first_name} #{Faker::Name.first_name}"}
    sender_email { "#{rand(1..300)}-#{rand(1..300)}@example.com" }
    message_type { "message-to-referent" }
  end
end
