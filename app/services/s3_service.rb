class S3Service < Service
  class Error < Service::ServiceError; end

  extend ReportableExceptionHelper

  reportable_exception :copy_object, :delete_object, :upload_object, :signed_object_url,
    error: [StandardError, S3Service::Error, Aws::S3::Errors::ServiceError]

  # Deletes an object from an AWS S3 bucket
  #
  # @param options [Hash]
  # @raise [Error]
  # @return [True]
  # @see http://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Object.html#delete-instance_method
  def delete_object(options)
    client.delete_object(options)
    true
  end

  # Uploads an object to an AWS S3 bucket
  #
  # @param options [Hash]
  # @raise [Error]
  # @return [True]
  # @see http://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Object.html#put-instance_method
  def upload_object(options)
    client.put_object(options)
    true
  end

  # Retrieve/Fetch an object from an AWS S3 bucket
  #
  # @param options [Hash]
  # @raise [Error]
  # @return [String]
  # @see http://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Object.html#get-instance_method
  def get_object(options)
    object = client.get_object(options)
    object.body.string
  end

  # Copies an object from an AWS S3 bucket to another S3 bucket
  #
  # @param options [Hash]
  # @raise [Error]
  # @return [True]
  # @see http://docs.aws.amazon.com/sdkforruby/api/Aws/S3/Client.html#copy_object-instance_method
  def copy_object(options)
    client.copy_object(options)
    true
  end

  # Generate a signed url
  #
  # @param options [Hash]
  # @raise [Error]
  # @return [String]
  def signed_object_url(options)
    presigner.presigned_url(:get_object, **options)
  end

  private

  # @note Credentials are automatically set from env variables
  # @see https://github.com/aws/aws-sdk-ruby#configuration
  def client
    @client ||= Aws::S3::Client.new
  end

  # @note Credentials are automatically set from env variables
  # @see https://github.com/aws/aws-sdk-ruby#configuration
  def presigner
    @presigner ||= Aws::S3::Presigner.new
  end
end
