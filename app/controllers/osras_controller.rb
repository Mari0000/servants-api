class OsrasController < ApplicationController
  def index
    load_osras
    render json: OsraSerializer.new(@osras).serializable_hash
  end

  def show
    load_osra
    render_osra
  end

  def create
    build_osra
    save_osra
  end

  def update
    load_osra
    build_osra
    save_osra
  end

  def destroy
    load_osra
    @osra.destroy
    render_osra
  end

  def import 
  end 

  def export 
    load_osras
    send_data @osras.to_csv, file_name: "osras-#{Date.today}.csv"
  end 

  private

  def load_osras
    @osras = if params[:year]
               current_user.osras.by_year(params[:year])
             else 
               current_user.osras.latest 
             end 
  end

  def load_osra
    @osra = current_user.osras.find(params[:id])
  end

  def build_osra
    @osra ||= Osra.new
    @osra.attributes = osra_params
  end

  def save_osra
    isNewRecord = @osra.new_record?
    if isNewRecord
      @osra.church_id = current_user.church_id
    end
    if @osra.save
      if isNewRecord
          @osra_servant = OsraServant.create!(
            osra_id: @osra.id,
            user_id: current_user.id
          )
      end
      render_osra
    else
      render_osra_errors
    end
  end

  def render_osra
    render json: OsraSerializer.new(@osra).serializable_hash
  end

  def render_osra_errors
    render json: {
      error: @osra.errors.values.join(', ')
    }, status: :bad_request
  end

  def osra_params
    params.require(:osra).permit(
      :name,
      osra_servants_attributes: %i[id user_id _destroy],
      amin_osras_attributes: %i[id user_id _destroy]
    )
  end
end
