# == Schema Information
#
# Table name: notifications
#
#  id                :bigint           not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  notification_type :string
#  content           :string
#  user_id           :bigint
#  resolved          :boolean          default(FALSE)
#
require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
