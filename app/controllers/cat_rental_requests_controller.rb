class CatRentalRequestsController < ApplicationController
  before_action :require_cat_owner, only: [:approve, :deny]
  before_action :require_valid_requester, only: [:create]
  def approve
    current_cat_rental_request.approve!
    redirect_to cat_url(current_cat)
  end

  def create
    @rental_request = CatRentalRequest.new(cat_rental_request_params)
    if @rental_request.save
      redirect_to cat_url(@rental_request.cat)
    else
      flash.now[:errors] = @rental_request.errors.full_messages
      render :new
    end
  end

  def deny
    current_cat_rental_request.deny!
    redirect_to cat_url(current_cat)
  end

  def new
    @rental_request = CatRentalRequest.new
  end

  private
  def current_cat_rental_request
    @rental_request ||=
      CatRentalRequest.includes(:cat).find(params[:id])
  end

  def current_cat
    current_cat_rental_request.cat
  end

  def cat_rental_request_params
    params.require(:cat_rental_request)
      .permit(:cat_id, :end_date, :start_date, :status, :user_id)
  end

  def require_valid_requester
    unless params[:cat_rental_request][:user_id].to_i == current_user.id
        flash[:errors] = ["Can't request on behalf of others!"]
        redirect_to cats_url
    end
  end
end
