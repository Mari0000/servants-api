class ConferencesController < ApplicationController
  def index
    load_conferences
    render json: ConferenceSerializer.new(@conferences).serializable_hash
  end

  def show
    load_conference
    render_conference
  end

  def create
    build_conference
    save_conference
  end

  def update
    load_conference
    build_conference
    save_conference
  end

  def destroy
    load_conference
    @conference.destroy
    render_conference
  end

  def import 
  end 

  def export 
    load_conferences
    send_data @conferences.to_csv, file_name: "conferences-#{Date.today}.csv"
  end 

  private

  def load_conferences
    @conferences = if params[:date] 
                    Conference.by_date(params[:date])
                   elsif params[:year] 
                    Conference.by_year(params[:year])
                   else 
                    Conference.latest
                   end 
  end

  def load_conference
    @conference = Conference.find(params[:id])
  end

  def build_conference
    @conference ||= Conference.new
    @conference.attributes = conference_params
  end

  def save_conference
    if @conference.save
      render_conference
    else
      render_conference_errors
    end
  end

  def render_conference
    render json: ConferenceSerializer.new(@conference).serializable_hash
  end

  def render_conference_errors
    render json: {
      error: @conference.errors.full_messages.join(', ')
    }, status: :bad_request
  end

  def conference_params
    params.require(:conference).permit(
      :name, :price, :osra_id, :start_date, :end_date, :place, :no_of_attendees,
      conference_servants_attributes: %i[id user_id _destroy]
    )
  end
end
