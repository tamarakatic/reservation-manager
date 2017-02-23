class Customers::FriendsController < ApplicationController
  before_action :authenticate_customer!

  layout "home_page"

  def index
    @friends = current_customer.friends.order(:firstname, :lastname)
  end

  # DELETE / remove_friend
  def remove
    @friend = Customer.find(params[:friend_id])
    current_customer.remove_friend(@friend)

    respond_to do |format|
      format.html { redirect_to friends_path }
      format.js
    end
  end

end