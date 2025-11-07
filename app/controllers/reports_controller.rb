class ReportsController < ApplicationController
  before_action :set_listing
  before_action :require_login

  def new
    @report = @listing.reports.new
  end

  def create
    @report = @listing.reports.new(report_params)
    @report.user = current_user

    if @report.save
      redirect_to @listing, notice: "Thanks—our moderators will review this"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_listing
    @listing = Listing.find(params[:listing_id])
  end

  def report_params
    params.require(:report).permit(:reason)
  end
end