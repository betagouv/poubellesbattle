# == Schema Information
#
# Table name: messages
#
#  id               :bigint           not null, primary key
#  content          :string
#  sender_email     :string
#  sender_full_name :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  donvert_id       :bigint
#  message_type     :string
#  recipient_id     :bigint
#
require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
