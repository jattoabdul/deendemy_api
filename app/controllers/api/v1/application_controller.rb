module Api
  module V1
    class ApplicationController < ApplicationController
      include Api::V1::Permissionable

      before_action :authenticate_api_v1_user!
      after_action :tag_request, if: -> { current_api_v1_user.present? }

      rescue_from StandardError, with: :internal_server_error unless Rails.env.development?
      rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found_error
      rescue_from Mongo::Error::InvalidDocument, with: :invalid_error
      rescue_from Mongoid::Errors::InvalidCollection, with: :invalid_error
      # TODO: figure out how to rescue mongo db unique errors
      # rescue_from ActiveRecord::RecordNotUnique, with: :conflict_error
      rescue_from ActionController::ParameterMissing, with: :parameter_missing_error
      rescue_from ActionController::BadRequest, with: :bad_request_error

      private

      # Enrich error reporting
      def tag_request
        Raven.user_context(id: current_api_v1_user.id)
      end

      # @param message [String, Hash]
      def bad_request_error(message)
        error('BadRequest', message, 400)
      end

      # @param message [String, Hash]
      def forbidden_error(message = nil)
        error('Forbidden', message || 'Unauthorized to complete that action.', 403)
      end

      # @param e [ActiveRecord::RecordNotFound]
      def not_found_error(e)
        error('RecordNotFound', "The requested #{e.problem}", 404)
      end

      def conflict_error
        error('Conflict', 'The requested resource already exist.', 409)
      end

      # @param e [ActiveRecord::RecordInvalid]
      def invalid_error(e)
        error('RecordInvalid', e.record.errors.to_hash, 422)
      end

      # @param e [ActiveRecord::ParameterMissing]
      def parameter_missing_error(e)
        error('ParameterMissing', e.message, 422)
      end

      # @param e [StandardError]
      def internal_server_error(e)
        logger.error(e)
        Raven.capture_exception(e)
        error('InternalServerError', 'Sorry, there is a problem on our side.')
      end

      # @param code [String]
      # @param message [String, Hash]
      # @param status [Integer]
      def error(code, message, status = 500)
        render json: {
          error: { code: code, message: message }
        }, status: status
      end
    end
  end
end
