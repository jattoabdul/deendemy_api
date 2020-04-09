# Based on https://medium.com/appaloosa-store-engineering/make-a-failing-sidekiq-worker-call-a-method-after-a-specific-number-of-retries-709d7f2cb9f3
module Sidekiq
  module RetryMonitoring
    class Middleware
      def call(worker, job_params, _queue)
        worker.warn(job_params['jid'], *job_params['args']) if should_warn?(worker, job_params)
      rescue StandardError => e
        ::Rails.logger.error e
      ensure
        yield
      end

      private

      def should_warn?(worker, job)
        return false unless worker.is_a?(MonitoredWorker)

        # The retry_count is incremented after all middlewares have been called, hence the +1
        (Integer(job['retry_count']) + 1) == worker.threshold_retry_count_for_warn
      end
    end
  end
end
