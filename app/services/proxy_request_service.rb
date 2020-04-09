class ProxyRequestService < Service
  class Error < Service::ServiceError; end

  def proxy(url, method, payload = nil, **args)
    opts = (args || {}).merge(
      url: url, method: method, payload: payload,
      proxy: ENV.fetch('QUOTAGUARDSTATIC_URL', nil)
    ).compact
    RestClient::Request.execute(**opts)
  end
end

