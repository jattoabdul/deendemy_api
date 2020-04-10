module Tasks
  class SampleWorkerJob
    include Sidekiq::Worker

    def perform(*args)
      Rails.logger.info("I AM TESTING WORKERS - WOULD HAVE SENT: #{args.inspect}")
    end
  end
end
