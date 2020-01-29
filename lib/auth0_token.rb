
require 'uri'
require 'net/http'
require 'json'

class Auth0Token
    def initialize
        @client_secret = ENV["AUTH0_SECRET_KEY"]
        @client_id = ENV["AUTH0_CLIENT_ID"]
        @audience = ENV["AUTH0_MANAGE_AUDIENCE"]
    end

    def get_accesstoken
        url = URI("https://household.auth0.com/oauth/token")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(url)
        request["content-type"] = 'application/x-www-form-urlencoded'
        request.body = "grant_type=client_credentials&client_id=#{@client_id}&client_secret=#{@client_secret}&audience=#{@audience}"

        response = http.request(request)
        json = JSON.parse(response.read_body)
        return json["access_token"]
    end
end

