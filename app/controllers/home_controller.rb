class HomeController < BaseController

  # GET, POST api.domain.tld
  def index
    render json: { cool: true, ts: Time.current.to_i, release: ENV.fetch('HEROKU_SLUG_COMMIT', nil) }, status: 200
  end
end
