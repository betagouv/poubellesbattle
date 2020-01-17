# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
require 'open-uri'
require 'csv'
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Composteur.destroy_all
Donvert.destroy_all
# Composteur.create(address: '11 avenue Jean Mermoz, Pau', name: 'CC4-ARCENCIEL-PAU')
# Composteur.create(address: '3 rue du Pin, Pau', name: 'CC7-MIDI-PAU')
# Composteur.create(address: '73 boulevard Tourasse, Pau', name: 'CC19-TOURASSE-PAU')
# Composteur.create(address: '5 avenue du président Kennedy, Pau', name: 'CC1-CARLITOS-PAU')


csv_options = { col_sep: ';', force_quotes: true, quote_char: '"' }
filepath    = 'db/compo.csv'

CSV.foreach(filepath, csv_options) do |row|
  Composteur.create(
    name: row[2],
    address: row[3],
    residence_name: row[4],
    composteur_type: row[5],
    public: row[6] == 'oui',
    volume: row[14],
    participants: row[15],
    installation_date: "#{row[17]}-01-01",
    commentaire: row[19]
  )
  puts "#{row[2]} created"

  User.create(
    first_name: row[7],
    last_name: row[8],
    phone_number: "#{row[9]}",
    email: row[10],
    password: "123456",
    referent: true,
    composteur_id: Composteur.last.id
  )
    puts "#{row[8]} created"

end

# Donvert.create(
#   title: "Don de matière sèche chêne",
#   type_matiere_orga: "branchage",
#   description: "branchage de chênes et feuillus",
#   volume_litres: 45,
#   donneur_name: "Jardin collectif Magique",
#   donneur_address: "14, avenue de Tarbes, Pau, France",
#   donneur_tel: "0989098768",
#   donneur_email: "jardin@magique.com",
#   date_fin_dispo: "14/01/2020")

# Donvert.create(
#   title: "Don de matière sèche bananier",
#   type_matiere_orga: "branchage",
#   description: "branchage de bananier",
#   volume_litres: 36,
#   donneur_name: "Jardin collectif Magique",
#   donneur_address: "79, avenue de Tarbes, Pau, France",
#   donneur_tel: "0989098768",
#   donneur_email: "jardin@magique.com",
#   date_fin_dispo: "01/01/2020")

# Donvert.create(
#   title: "Don de compost",
#   type_matiere_orga: "compost",
#   description: "compost mûr",
#   volume_litres: 78,
#   donneur_name: "Composteur carlito",
#   donneur_address: "25, avenue de Lons, Pau, France",
#   donneur_tel: "0989098456",
#   donneur_email: "compo@carli.com",
#   date_fin_dispo: "09/12/2019")
