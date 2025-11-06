# app/controllers/reports_controller.rb
class ReportsController < ApplicationController
  before_action :set_listing, only: [:new, :create] 

  def new
    @report = @listing.reports.new
    render plain: "OK"
  end

  def create
    @report = @listing.reports.new(report_params)
    @report.user = @listing.user

    if @report.save
      redirect_to @listing, notice: 'Report was successfully created.'
    else

      render :new
    end
  end
  # ----------------------------

  private

  def set_listing
    @listing = Listing.find(params[:listing_id])
  end

  def report_params
    params.require(:report).permit(:reason)
  end
  # ----------------------------------
end
