class WidgetsController < ApplicationController
  def index
    return unless _route_authorized

    @widgets = current_user.widgets
    render json: @widgets
  end

  def show
    return unless _route_authorized

    if @widget = Widget.where(:id => params[:id], :user => current_user)
      render json: @widget
    else
      render json: { success: false }
    end
  end

  def create
    return unless _route_authorized

    @widget = Widget.new(_widget_params.merge(:user => current_user))
    if @widget.save
      render json: @widget
    else
      render json: @widget.errors
    end
  end

  def update
    return unless _route_authorized

    @widget = Widget.find(params[:id])
    if @widget.user_id != current_user.id
      render json: { :message => "unauthorized" }
    elsif @widget.update(_widget_params.merge(:user => current_user))
      render json: @widget 
    else
      render json: @widget.errors
    end
  end

  def destroy
    return unless _route_authorized

    @widget = Widget.find(params[:id])
    if @widget.user_id != current_user.id
      render json: { :message => "unauthorized" }
    elsif @widget.destroy
      render json: { success: true }
    else
      render json: @widget.errors
    end
  end

  private 

  def _widget_params
    params.require(:widget_details).permit(:name, :quantity, :value_in_cents)
  end

  def _route_authorized
    render json: { :message => "unauthorized" } if !logged_in?

    logged_in?
  end
end