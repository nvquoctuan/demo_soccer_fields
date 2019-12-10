class PitchesController < ApplicationController
  before_action :load_time, only: :index
  def create; end

  def index
    if params[:pitch]
    @pitches = Pitch.search_city(params[:pitch][:city])
                    .search_district(params[:pitch][:district])
                    .search_pitches(params[:pitch][:address])
                    .search_time(@start_time, @end_time)
                    .paginate page: params[:page],
                                             per_page: Settings.size.s_12
    else
      @pitches = Pitch.latest_pitches.paginate page: params[:page],
                                                   per_page: Settings.size.s_12
    end
      respond_to do |format|
        if @pitches
          format.js
        end
      end
  end

  private
  def load_time
    if params[:pitch]
      @start_time = Time.strptime(params[:pitch]["start_time(4i)"] <<
                          ":" << params[:pitch]["start_time(5i)"], "%H:%M")
      @end_time = Time.strptime(params[:pitch]["end_time(4i)"] <<
                        ":" << params[:pitch]["end_time(5i)"], "%H:%M")
    end
  end
end
