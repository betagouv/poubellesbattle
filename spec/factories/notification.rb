FactoryBot.define do
  factory :notification do
    content { "Je fais un dépot" }
    notification_type { "depot" }
  end
end
