class PurchasesController < ApplicationController
  def index
    @purchases = Purchase.includes(:listing)
                         .where(buyer: current_user)
                         .order(purchased_at: :desc)
  end
end

