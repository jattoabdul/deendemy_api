module DelayedAction
  class CreateEventJob
    include Sidekiq::Worker

    def perform(*args)
      Event.create(*args)
    end
  end
end