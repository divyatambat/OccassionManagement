class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :update, :destroy]
  load_and_authorize_resource

  def index
    if current_user.customer?
      @bookings = current_user.bookings
    elsif current_user.admin?
      @bookings = Booking.all
      apply_filters
    end

    render json: @bookings
  end

  def show
    render json: @booking
  end

  def create
    @booking = Booking.new(booking_params)

    if @booking.save
      render json: @booking, status: :created
    else
      render json: { error: I18n.t('errors.booking_create_failed') }, status: :unprocessable_entity
    end
  end

  def update
    if @booking.nil?
      render json: { error: I18n.t('errors.record_not_found') }, status: :not_found
    elsif @booking.user != current_user
      render json: { error: I18n.t('errors.unauthorized_update') }, status: :unauthorized
    elsif @booking.update(booking_params)
      render json: @booking
    else
      render json: { error: I18n.t('errors.booking_update_failed') }, status: :unprocessable_entity
    end
  end

  def destroy
    if @booking.nil?
      render json: { error: I18n.t('errors.record_not_found') }, status: :not_found
    elsif @booking.user != current_user
      render json: { error: I18n.t('errors.unauthorized_delete') }, status: :unauthorized
    else
      @booking.destroy
      render json: { message: 'Booking with ID ' + params[:id] + ' was successfully destroyed' }
    end
  end

  private

  def apply_filters
    @bookings = @bookings.where(venue_id: params[:venue_id]) if params[:venue_id].present?
    @bookings = @bookings.where(user_id: params[:user_id]) if params[:user_id].present?
    @bookings = @bookings.where(booking_date: params[:booking_date]) if params[:booking_date].present?
    @bookings = @bookings.where(status: params[:status]) if params[:status].present?
    @bookings = @bookings.where('start_time >= ? AND end_time <= ?', params[:start_time], params[:end_time]) if params[:start_time].present? && params[:end_time].present?
  end

  def set_booking
    @booking = Booking.find_by(id: params[:id])
  end

  def booking_params
    params.require(:booking).permit(:user_id, :venue_id, :booking_date, :start_time, :end_time, :status)
  end
end
