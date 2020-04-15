class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def stats
    return unless current_user.role == "admin"
    @users_count = User.count
  end
end
