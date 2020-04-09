module Sidekiq
  module RetryMonitoring
    module MonitoredWorker
      def threshold_retry_count_for_warn
        5
      end

      # Override in child classes
      def warn(_jid, *_params)
        Rails.logger.warn "Called default #warn for #{self.class}"
      end
    end
  end
end
