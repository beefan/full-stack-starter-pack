class SalesController < ApplicationController
  def create
    return unless _route_authorized

    @sale = Sale.new(_sale_params)
    if @sale.widget&.user_id != current_user.id
      render json: { :message => "unauthorized" }
    elsif @sale.save
      render json: @sale
    else
      render json: @sale.errors
    end
  end

  def destroy
    return unless _route_authorized

    @sale = Sale.find(params[:id])
    if @sale.widget&.user_id != current_user.id
      render json: { :message => "unauthorized" }
    elsif @sale.destroy
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  private

  def _sale_params
    params.require(:sale_details).permit(:widget_id, :quantity)
  end

  def _route_authorized
    render json: { :message => "unauthorized" } if !logged_in?

    logged_in?
  end
end