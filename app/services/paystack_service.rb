class PaystackService < Service
  class Error < Service::ServiceError; end

  include ActionController::Helpers
  extend ReportableExceptionHelper

  reportable_exception :verify_transaction,
     error: [StandardError, PaystackService::Error, HTTParty::ResponseError]

  # Verify a transaction from Paystack
  # @note Credentials (PAYSTACK_SECRET_KEY) are automatically set from env variables
  # @param transaction_ref [String]
  # @raise [Error]
  # @return [HTTParty::Response]
  # @see https://github.com/samuel52/PaystackRubyApi/tree/master
  def verify_transaction(transaction_ref)
    Paystackapi::PaystackTransactions.verify(transaction_ref)
  end
end
