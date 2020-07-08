FactoryBot.define do
  factory :donvert do
    title { "Ma super annonce"}
    description { "C'est vraiment une super offre" }
    donateur_type { "site de compostage" }
    type_matiere_orga { "compost" }
    donneur_name { "#{Faker::Name.first_name}" }
    donneur_address { "#{rand(1..1000)} rue du Hédas, Pau" }
    donneur_email { "#{rand(1..300)}-#{rand(1..300)}@example.com"}
    donneur_tel { "+334#{rand(11111111..99999999)}" }
    date_fin_dispo { Date.today + 3.weeks }
  end
end
