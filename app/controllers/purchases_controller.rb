class PurchasesController < ApplicationController
  def index
    buyer = current_user
    purchases = Purchase.includes(:listing)
                        .where(buyer: buyer)
                        .order(purchased_at: :desc)

    if purchases.empty?
      render plain: 'No purchases yet'
    else
      body = purchases.map do |p|
        title = p.listing&.title.to_s
        price = format('%.2f', p.price)
        date  = p.purchased_at.to_date.to_s
        "#{title} - #{price} - #{date}"
      end.join("\n")

      render plain: body
    end
  end
end

