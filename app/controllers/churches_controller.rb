class ChurchesController < ApplicationController
  before_action :load_church, except: %i[index create export import]
  before_action :load_churches, only: %i[index]
  before_action :build_church, only: %i[create update]

  def index
    render json: @churches
  end

  def show
    render json: @church
  end

  def create
    save_church
  end

  def update
    save_church
  end

  def destroy
    @church.destroy
    render json: @church
  end

  def import 
  end 

  def export 
    load_churches
    send_data @churches.to_csv, file_name: "churches-#{Date.today}.csv"
  end 

  private

  def load_churches
    @churches = if params[:year] 
                  Church.by_year(params[:year])
                else 
                  Church.latest 
                end 
  end

  def load_church
    @church = Church.find(params[:id])
  end

  def build_church
    @church ||= Church.new
    @church.attributes = church_params
  end

  def save_church
    if @church.save
      render json: @church
    else
      render_church_errors
    end
  end

  def render_church_errors
    render json: {
      error: @church.errors.full_messages.to_sentence
    }, status: :bad_request
  end

  def church_params
    params.require(:church).permit(:id, :name, :country, :city, :address)
  end
end
