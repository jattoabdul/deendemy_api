class SaveImageToS3Job
  include Sidekiq::Worker
  sidekiq_options queue: :uploader, retry: 2

  # @param id [Object] Media Attribute
  def perform(attributes)
    media = Media.new(attributes)
    media.save_and_process_item(:now => true)
  end
end
