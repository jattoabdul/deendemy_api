require 'rails_helper'

RSpec.describe Api::V1::PaymentsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/payments').to route_to('api/v1/payments#index', format: :json)
    end

    it 'routes to #fetch_learner_payments' do
      expect(get: '/api/v1/payments/learners/1').to route_to('api/v1/payments#fetch_learner_payments', learner_id: '1', format: :json)
    end

    it 'routes to #fetch_single_payment' do
      expect(get: '/api/v1/payments/1').to route_to('api/v1/payments#fetch_single_payment', id: '1', format: :json)
    end

    it 'routes to #charge' do
      expect(post: '/api/v1/payments/charge').to route_to('api/v1/payments#charge', format: :json)
    end
  end
end
