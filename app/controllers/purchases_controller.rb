class PurchasesController < ApplicationController
  before_action :require_login
  def index
    @purchases = Purchase.includes(:listing)
                         .where(buyer: current_user)
                         .order(purchased_at: :desc)
  end
end