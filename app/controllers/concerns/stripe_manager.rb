
module StripeManager
  extend ActiveSupport::Concern

  def plan_info(plan_id)
    plan_id.nil? ?  false : Stripe::Plan.retrieve(plan_id)
  rescue Stripe::InvalidRequestError => e
    render json: {message: e.message}, status: :bad_request
    return
  rescue Stripe::StripeError => e
    render json: {message: e.message}, status: :internal_server_error
    return
  end

  def invoices
    Stripe::Invoice.list(limit: 50)
  end

  def cancel_subscription(sub_id)
    Stripe::Subscription.delete(@org.subscription_basic_id) 
  rescue Stripe::InvalidRequestError => e
    render json: {message: e.message}, status: :bad_request
    return
  rescue Stripe::StripeError => e
    render json: {message: e.message}, status: :internal_server_error
    return
  end

  def apply_subscription(customer_id, plan)
    Stripe::Subscription.create(
       customer: customer_id,
       plan: plan
    )
  rescue Stripe::InvalidRequestError => e
    render json: {message: e.message}, status: :bad_request
    return
  rescue Stripe::StripeError => e
    render json: {message: e.message}, status: :internal_server_error
    return
  end

  def create_customer(token, client , detail)
    Stripe::Customer.create(
       :email => client,
       :source => token,
       :description => detail
    )
  rescue Stripe::InvalidRequestError => e
    render json: {message: e.message}, status: :bad_request
    return
  rescue Stripe::StripeError => e
    render json: {message: e.message}, status: :internal_server_error
    return
  end

end
