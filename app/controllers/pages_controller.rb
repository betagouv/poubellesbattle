class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def stats
    @users_count = User.count
  end
end
