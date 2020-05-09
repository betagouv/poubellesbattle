# == Schema Information
#
# Table name: donverts
#
#  id                :bigint           not null, primary key
#  title             :string
#  type_matiere_orga :string
#  description       :string
#  volume_litres     :float
#  donneur_name      :string
#  donneur_address   :string
#  donneur_tel       :string
#  donneur_email     :string
#  date_fin_dispo    :date
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  slug              :string           not null
#  pourvu            :boolean          default(FALSE)
#  donateur_type     :string
#  user_id           :bigint
#  codeword          :string
#  archived          :boolean          default(FALSE)
#
require 'test_helper'

class DonvertTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
