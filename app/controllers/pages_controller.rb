class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def stats
    return unless current_user.role == "admin"
    users = User.all
    @users_count = users.count
    @users_last_month = 0
    users.each { |user| user.created_at.month < Date.today.month ? @users_last_month += 1 : @users_last_month }
  end
end
