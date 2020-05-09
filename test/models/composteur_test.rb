# == Schema Information
#
# Table name: composteurs
#
#  id                :bigint           not null, primary key
#  latitude          :float
#  longitude         :float
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  address           :string
#  name              :string
#  category          :string
#  public            :boolean
#  installation_date :date
#  status            :string
#  volume            :string
#  residence_name    :string
#  commentaire       :string
#  participants      :integer
#  composteur_type   :string
#  date_retournement :date
#  manual_lat        :float
#  manual_lng        :float
#
require 'test_helper'

class ComposteurTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
