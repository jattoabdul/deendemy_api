# https://robots.thoughtbot.com/catching-json-parse-errors-with-custom-middleware
class RescueJsonParseErrors
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue ActionDispatch::Http::Parameters::ParseError => e
    if /application\/json/.match?(env['CONTENT_TYPE'])
      error_output = "There was a problem in the JSON you submitted: #{e}"
      [
        400, { 'Content-Type' => 'application/json' },
        [{ error: { code: 'BadRequest', message: error_output } }.to_json]
      ]
    else
      raise e
    end
  end
end
