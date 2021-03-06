
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
  password: SecureRandom.base64(16).to_s,
  role: 2
)

Notification.create(
  notification_type: "message-admin",
  content: "Bonjour, Une livraison de broyat pour les sites de compostage collectifs ou de quartier est prévue #{Date.today + 15.days}. Si vous en avez besoin, merci de m'écrire à contact@poubelles-battle.fr",
  user_id: admin.id
)

i = 1
100.times do
  compo = Composteur.create(
    name: "#{rand(1..1000)}-#{Faker::Name.last_name}",
    address: "#{rand(1..100)} #{[ "rue du hédas",
                                  "rue du 14 juillet",
                                  "rue du Capitaine Guynemer",
                                  "rue du Colonel Gloxin",
                                  "rue du 8 mai 1945",
                                  "rue castetnau",
                                  "boulevard de la paix",
                                  "avenue du béarn",
                                  "avenue du loup"
                                ].sample}, Pau",
    category: ["composteur de quartier", "composteur bas d'immeuble"].sample,
    public: [true, true, false].sample
    )

  # puts "#{compo.name} created"

  10.times do
    user = User.new(
      email: "#{rand(1..300)}-#{rand(1..300)}@example.com",
      password: SecureRandom.base64(6).to_s,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      role: [0, 0, 1].sample
    )

    user.composteur_id = compo.id

    next unless user.save

    Notification.create!(
      notification_type: "message",
      content: "Salut, je suis #{user.first_name} ! C'est parti pour le compost !",
      user_id: user.id
    )
    if user.id.odd?
      Notification.create!(
        notification_type: "depot",
        content: "#{user.first_name} vient de faire un dépot !",
        user_id: user.id
      )
      if user.first_name.length.odd?
        Notification.create!(
          notification_type: "depot",
          content: "#{user.first_name} vient de faire un dépot !",
          user_id: user.id
        )
      end
    else
      Notification.create!(
        notification_type: "anomalie",
        content: "manque de structurant",
        user_id: user.id
      )
    end

    next unless user.referent?

    user.phone_number = "06#{rand(00000000..99999999)}"
    user.ok_phone = [true, true, false].sample
    user.ok_mail = [true, true, false].sample
    user.save!

    Notification.create(
      notification_type: "message-ref",
      content: "Bonjour ! Je suis #{user.first_name} !",
      user_id: user.id
    )
  end
  puts i.to_s
  i += 1
end


# # csv_options = { col_sep: ';', force_quotes: true, quote_char: '"' }
# # filepath    = 'db/compo.csv'

# # CSV.foreach(filepath, csv_options) do |row|
# #   compo = Composteur.create(
# #     name: row[2],
# #     address: row[3],
# #     residence_name: row[4],
# #     composteur_type: row[5],
# #     public: row[6] == 'oui',
# #     volume: row[14],
# #     participants: row[15],
# #     installation_date: "#{row[17]}-01-01",
# #     status: "installé",
# #     commentaire: row[19]
# #   )
# #   puts "#{row[2]} created"

# #   user = User.new(
# #     first_name: row[8],
# #     last_name: row[7],
# #     phone_number: "0#{row[9]}",
# #     email: row[10] != nil ? row[10] : "random.#{rand(100..500)}@mail.com",
# #     password: "#{rand(100000..900000)}",
# #     role: "référent",
# #     ok_phone: row[11] = "oui" ,
# #     ok_mail: row[12] = "oui"
# #   )
# #   user.composteur_id = compo.id

# #   if user.save
# #     puts "#{row[8]} created"

# #     Notification.create(
# #       notification_type: "welcome",
# #       content: "Bienvenue #{row[8]} ! C'est parti pour le compost !",
# #       user_id: user.id
# #     )
# #     puts "welcome notification created"
# #     Notification.create(
# #       notification_type: "message-ref",
# #       content: "Bonjour ! Je suis #{row[8]} !",
# #       user_id: user.id
# #     )
# #     puts "ref message created"
# #   end
# # end

# # User.create(
# #   email: "random.#{rand(100..500)}@mail.com",
# #   password: "123456",
# #   role: "",
# #   first_name: "Brandon",
# #   last_name: "Joe",
# #   ok_mail: true,
# #   ok_phone: true,
# #   composteur_id: Composteur.last.id
# # )

# # User.create(
# #   email: "random.#{rand(100..500)}@mail.com",
# #   password: "123456",
# #   role: "",
# #   first_name: "Junior",
# #   last_name: "Joe",
# #   ok_mail: true,
# #   ok_phone: true,
# #   composteur_id: Composteur.last.id
# # )

# # User.create(
# #   email: "random.224@mail.com",
# #   password: "123456",
# #   role: "référent",
# #   first_name: "Patrick",
# #   last_name: "Joe",
# #   ok_mail: true,
# #   ok_phone: true,
# #   phone_number: "0123456789",
# #   composteur_id: Composteur.last.id
# # )

