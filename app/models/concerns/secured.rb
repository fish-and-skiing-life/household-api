# frozen_string_literal: true

module Secured
  extend ActiveSupport::Concern

  SCOPES = {
    '/api/private-scoped' => ['read:messages'] # scopeが必要なrequestはこのように記載
  }.freeze

  included do
    before_action :authenticate_request!, except: [:preview, :create_answer,  :export_pdf]
    after_action :logging_create
  end

  def current_user
    @user
  end

  def current_org
    @org
  end

  private
  def logging_create
    Logs.create_log(@user, @org, params, request, response)
  end

  def authenticate_request!
    @auth_payload, @auth_header = auth_token
    @user = User.from_token_payload(@auth_payload)

    render json: { path: '/startup' }, status: :moved_permanently unless exist_organization
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

  def exist_organization
    if @user.organization.nil?
      request.original_fullpath == '/api/v1/organization/create' || request.original_fullpath == '/api/v1/organization/plans_list'
    else
      @org = @user.organization
      true
    end
  end

  def scope_included
    if SCOPES[request.env['PATH_INFO']].nil?
      true
    else
      (String(@auth_payload['scope']).split(' ') & (SCOPES[request.env['PATH_INFO']])).any?
    end
  end
end
