FactoryBot.define do
  factory :composteur do
    name { "CC-#{Faker::Name.last_name}" }
    address { "#{rand(1..100)} rue du Hédas, Pau" }
    category { ["composteur de quartier", "composteur bas d'immeuble"].sample }
    public { true }
  end
end
