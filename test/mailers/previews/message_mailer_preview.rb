class MessageMailerPreview < ActionMailer::Preview
  def interest_don
    message = Message.last

    MessageMailer.with(message: message).interest_don
  end
end
