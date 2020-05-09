# == Schema Information
#
# Table name: demandes
#
#  id                 :bigint           not null, primary key
#  status             :string
#  logement_type      :string
#  inhabitant_type    :string
#  address            :string
#  location_found     :boolean
#  email              :string
#  first_name         :string
#  last_name          :string
#  phone_number       :string
#  potential_users    :boolean
#  completed_form     :boolean
#  planification_date :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  slug               :string           not null
#  potential_address  :string
#  notes_to_collegues :string
#
require 'test_helper'

class DemandeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
