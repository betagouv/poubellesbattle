require 'open-uri'
require 'csv'
require 'faker'

Notification.destroy_all
Message.destroy_all
Donvert.destroy_all
User.destroy_all
Composteur.destroy_all
Donvert.destroy_all


admin = User.create(
  email: "admin@mail.com",
  password: "123456",
  role: "admin",
  first_name: "admin",
  last_name: "admin"
)

Notification.create(
  notification_type: "message-admin",
  content: "Bonjour, Une livraison de broyat pour les sites de compostage collectifs ou de quartier est prévue Mardi 30 juin. Si vous en avez besoin, merci de m'écrire à e.morello@agglo-pau.fr",
  user_id: admin.id
)

100.times do
  compo = Composteur.create(
    name: "#{rand(1..1000)}-#{Faker::Name.last_name}",
    address: "#{rand(1..100)} rue du #{["hédas", "14 juillet", "Capitaine Guynemer", "Colonel Gloxin", "8 mai 1945"].sample}, Pau",
    category: ["composteur de quartier", "composteur bas d'immeuble"].sample,
    public: [true, true, false].sample
    )

  puts "#{compo.name} created"

  5.times do
    user = User.new(
      email: "#{rand(1..300)}-#{rand(1..300)}@example.com",
      password: "123456",
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      role: [0, 0, 1].sample
      )

    user.composteur_id = compo.id

    if user.save
      puts "#{user.first_name} created"

      Notification.create(
        notification_type: "welcome",
        content: "Salut, je suis #{user.first_name} ! C'est parti pour le compost !",
        user_id: user.id
      )
      puts "welcome notification created"

      if user.referent?
        Notification.create(
          notification_type: "message-ref",
          content: "Bonjour ! Je suis #{user.first_name} !",
          user_id: user.id
        )
        puts "ref message created"
      end
    end
  end
end
