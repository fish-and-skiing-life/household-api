# frozen_string_literal: true

module Secured
  extend ActiveSupport::Concern

  SCOPES = {
    '/api/private-scoped' => ['read:messages'] # scopeが必要なrequestはこのように記載
  }.freeze

  included do
    before_action :authenticate_request!, except: [:preview, :create_answer,  :export_pdf]
  end

  def current_user
    @user
  end

  private
  def authenticate_request!
    @auth_payload, @auth_header = auth_token
    @user = User.from_token_payload(@auth_payload)
    if @user.name.nil? && request.original_fullpath != '/api/v1/name_update'
      render json: { path: '/startup',user: @user }, status: :moved_permanently
    else
      true
    end
  rescue JWT::VerificationError,JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

  def http_token
    if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    end
  end

  def auth_token
    JsonWebToken.verify(http_token)
  end

  def scope_included
    if SCOPES[request.env['PATH_INFO']].nil?
      true
    else
      (String(@auth_payload['scope']).split(' ') & (SCOPES[request.env['PATH_INFO']])).any?
    end
  end
end
