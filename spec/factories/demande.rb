FactoryBot.define do
  factory :demande do
    first_name { "#{Faker::Name.first_name}" }
    last_name { "#{Faker::Name.last_name}" }
    email { "#{rand(1..300)}-#{rand(1..300)}@example.com"}
    phone_number { "+334#{rand(11111111..99999999)}" }
    address { "#{rand(1..1000)} rue du Hédas, Pau" }
    logement_type { "maison" }
    inhabitant_type { "locataire" }
    potential_users { true }
  end
end
