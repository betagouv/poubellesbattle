FactoryBot.define do
  factory :composteur do
    name { "#{rand(1..1000)}-#{Faker::Name.last_name}" }
    address { "#{rand(1..1000)} rue du Hédas, Pau" }
    category { ["composteur de quartier", "composteur bas d'immeuble"].sample }
    public { true }
  end
end
