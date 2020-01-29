module Auth0Manager 
  extend ActiveSupport::Concern

  def user(sub)
    auth0_client.user(sub) 
  end

  def seach_by_email(email)
    auth0_client.users_by_email(email)
  end

  private 
  # Setup the Auth0 API connection.
  def auth0_client
    @auth0_client ||= Auth0Client.new(
      client_id: ENV["AUTH0_CLIENT_ID"],
      client_secret: ENV["AUTH0_SECRET_KEY"],
      token: Auth0Token.new.get_accesstoken(),
      domain: ENV["AUTH0_DOMAIN"],
      api_version: 2,
      timeout: 15 # optional, defaults to 10
    )
  end
end 
