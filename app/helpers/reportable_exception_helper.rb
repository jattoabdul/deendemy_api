module ReportableExceptionHelper
  # Exception wrapper to report and normalize an error
  # @return [Anything]
  def reportable_exception(*method_names, error: StandardError)
    method_names.each do |m|
      proxy = Module.new do
        define_method(m) do |*args|
          super(*args)
        rescue *error => e
          Rails.logger.error("ERROR: #{e.message}")
          Raven.capture_exception(e)
          raise StandardError, e.message
        end
      end
      prepend(proxy)
    end
  end
end
