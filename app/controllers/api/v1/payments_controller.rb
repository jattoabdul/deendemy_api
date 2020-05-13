class Api::V1::PaymentsController < Api::V1::ApplicationController
  before_action :set_payment, only: [:fetch_single_payment]
  before_action :set_learner, only: [:fetch_learner_payments]

  ALLOWED_PAYMENT_PROCESSORS = [Payment::PAYMENT_CHANNEL_PAYSTACK, Payment::PAYMENT_CHANNEL_PAYPAL, Payment::PAYMENT_CHANNEL_STRIPE].freeze

  # GET /payments
  def index
    bad_request_error('Unauthorized Access to Payments Detail') && return unless current_api_v1_user.roles.include?('admin')
    @payments = Payment.all
    # TODO: Add pagination, fetch only first 20 by default
    render json: @payments
  end

  # GET /payments/learners/:learner_id
  def fetch_learner_payments
    bad_request_error('Unauthorized Access to Payments Detail') && return unless payment_learner_or_admin?
    @payments = Payment.where(user_id: @learner.id)
    # TODO: Add pagination, fetch only first 20 by default
    render json: @payments
  end

  # GET /payments/1
  def fetch_single_payment
    bad_request_error('Unauthorized Access to Payment Detail') && return unless payment_owner_or_admin?
    render json: @payment
  end

  # POST /payments/charge
  def charge
    payment_success = false
    processor = charge_payment_params[:processor].strip.downcase
    bad_request_error('Payment processor passed not allowed') && return unless ALLOWED_PAYMENT_PROCESSORS.include?(processor)
    
    cart_id = charge_payment_params[:cart_id]
    course_items = Cart.includes(:items).find(cart_id).items

    charge_params = {
      user_id: current_api_v1_user.id,
      processor: processor,
      comment: charge_payment_params[:comment]
    }
  
    if processor == Payment::PAYMENT_CHANNEL_PAYSTACK
      reference = charge_payment_params[:reference]
      # check if payment with this reference already exist
      payment = begin
                  Payment.find_by(reference: reference)
                rescue StandardError
                  nil
                end
      bad_request_error('Invalid request') && return if payment

      charge_params[:reference] = reference

      # Verify Payment at Paystack
      paystack_data = paystack.verify_transaction(reference)

      # Paystack Payment Verification Failure Check.
      # Temporarily added the or statement, take it out later after proper testing
      unless paystack_data['data']['status'] == 'success' || paystack_data['data']['status'] == 'abandoned'
        bad_request_error('Paystack Payment Verification Failed. Please Contact Support')
        return
      end

      payment_success = true
    else
      bad_request_error('payment processor passed not supported') && return
    end

    if payment_success
      subtotal = course_items.map(&:price).sum
      charge_params[:status] = true
      charge_params[:currency_iso] = subtotal.currency.iso_code
      charge_params[:subtotal_pence] = subtotal.cents
      charge_params[:total_pence] = charge_params[:subtotal_pence]

      # TODO: Calculate Tax and Add to Total
      # charge_params[:tax_rate] = 0.0 # for now use 0.0 as we are not handling taxes for now
      # charge_params[:tax_pence] = charge_params[:tax_rate] * charge_params[:subtotal_pence]
      # charge_params[:total_pence] = charge_params[:subtotal_pence] + charge_params[:tax_pence]

      # Insert Payment Row
      @payment = Payment.new(charge_params)
      if @payment.save
        # For each course items
        course_items.each do |course|
          # Insert Enrollment Row
          enrollment_data = {
              'payment_id': @payment.id,
              'course_id': course.id,
              'learner_id': @payment.user.id,
              'status': 'started',
              'progress': 0
          }
          @payment.enrollments.create!(enrollment_data)
        end
        # TODO: Send Payment Successful Email
        render json: @payment, status: :created
      else
        render json: @payment.errors, status: :unprocessable_entity
      end
    end
  end

  private
  def paystack
    @paystack ||= PaystackService.new
  end

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def set_learner
    @learner = User.find(params[:learner_id])
  end

  def charge_payment_params
    params.require(:payment).permit(:cart_id, :processor, :comment, :reference).tap do |charge_params|
      charge_params.require(:processor)
      charge_params.require(:cart_id)
      charge_params.require(:reference) if charge_params[:processor] == Payment::PAYMENT_CHANNEL_PAYSTACK
    end
  end

  def payment_owner_or_admin?
    (@payment.user_id == current_api_v1_user.id) || current_api_v1_user.roles.include?('admin')
  end

  def payment_learner_or_admin?
    (@learner.id == current_api_v1_user.id) || current_api_v1_user.roles.include?('admin')
  end

  # Generates a short, unique reference ID
  def generate_reference
    reference = loop do
      ref = SecureRandom.hex(3)
      break ref unless Payment.where(reference: ref).exists?
    end

    reference
  end
end
