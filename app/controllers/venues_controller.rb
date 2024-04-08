class VenuesController < ApplicationController
  before_action :set_venue, only: [:show, :update, :destroy]
  load_and_authorize_resource

  def index
    @venues = Venue.all
    if params[:venue_type].present?
      @venues = @venues.where(venue_type: params[:venue_type])
    end
    render json: @venues
  end

  def show
    render json: @venue
  end

  def create
    @venue = Venue.new(venue_params)

    if @venue.save
      render json: @venue, status: :created
    else
      render json: { error: I18n.t('errors.venue_create_failed') }, status: :unprocessable_entity
    end
  end

  def update
    if @venue.update(venue_params)
      render json: @venue
    else
      render json: { error: I18n.t('errors.venue_update_failed') }, status: :unprocessable_entity
    end
  end

  def destroy
    if @venue
      @venue.destroy
      render json: { message: 'Venue deleted successfully.' }
    else
      render json: { error: I18n.t('errors.record_not_found') }, status: :not_found
    end
  end

  private

  def set_venue
    @venue = Venue.find_by(id: params[:id])
  end

  def venue_params
    params.require(:venue).permit(:name, :venue_type, :start_time, :end_time)
  end
end
