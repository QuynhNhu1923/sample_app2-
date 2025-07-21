class MicropostsController < ApplicationController
  before_action :logged_in_user

  def index
    @microposts = Micropost.recent
  end
end
