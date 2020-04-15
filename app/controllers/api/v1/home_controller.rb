class Api::V1::HomeController < Api::V1::ApplicationController
  # before_action :authenticate_api_v1_user!
  # before_action :authenticate_user!

  # GET, POST api.domain.tld
  def index
    render json: { cool: true, ts: Time.current.to_i, version: 1 }, status: 200
  end
end
