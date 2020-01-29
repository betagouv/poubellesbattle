require 'open-uri'
require 'csv'

Notification.destroy_all
User.destroy_all
Composteur.destroy_all
Donvert.destroy_all

csv_options = { col_sep: ';', force_quotes: true, quote_char: '"' }
filepath    = 'db/compo.csv'

User.create(
  email: "admin@mail.com",
  password: "123456",
  role: "admin"
)

CSV.foreach(filepath, csv_options) do |row|
  compo = Composteur.create(
    name: row[2],
    address: row[3],
    residence_name: row[4],
    composteur_type: row[5],
    public: row[6] == 'oui',
    volume: row[14],
    participants: row[15],
    installation_date: "#{row[17]}-01-01",
    status: "installé",
    commentaire: row[19]
  )
  puts "#{row[2]} created"

  user = User.new(
    first_name: row[8],
    last_name: row[7],
    phone_number: "0#{row[9]}",
    email: row[10] != nil ? row[10] : "random.#{rand(100..500)}@mail.com",
    password: "123456",
    role: "référent",
    ok_phone: row[11] = "oui" ,
    ok_mail: row[12] = "oui"
  )
  user.composteur_id = compo.id

  if user.save
    puts "#{row[8]} created"

    Notification.create(
      notification_type: "welcome",
      content: "Bienvenue #{row[8]} ! C'est parti pour le compost !",
      user_id: user.id
    )
    puts "welcome notification created"
  end
end

User.create(
  email: "random.#{rand(100..500)}@mail.com",
  password: "123456",
  role: "",
  first_name: "Brandon",
  last_name: "Joe",
  ok_mail: true,
  ok_phone: true,
  composteur_id: Composteur.last.id
)

User.create(
  email: "random.#{rand(100..500)}@mail.com",
  password: "123456",
  role: "",
  first_name: "Junior",
  last_name: "Joe",
  ok_mail: true,
  ok_phone: true,
  composteur_id: Composteur.last.id
)

User.create(
  email: "random.#{rand(100..500)}@mail.com",
  password: "123456",
  role: "",
  first_name: "Patrick",
  last_name: "Joe",
  ok_mail: true,
  ok_phone: true,
  composteur_id: Composteur.last.id
)
