class ReportsController < ApplicationController
  before_action :set_listing, only: [:new, :create]

  def new
    # Build a new report for the form
    @report = @listing.reports.new
  end

  def create
    @report = @listing.reports.new(report_params)
    # Assign current_user if available (works with Devise or similar). If no user, leave nil.
    @report.user = current_user if respond_to?(:current_user) && current_user

    if @report.save
      redirect_to @listing, notice: "Report submitted."
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