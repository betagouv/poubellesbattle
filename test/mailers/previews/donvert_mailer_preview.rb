class DonvertMailerPreview < ActionMailer::Preview
  def confirmation_don
    donvert = Donvert.last

    DonvertMailer.with(donvert: donvert).confirmation_don
  end
end
