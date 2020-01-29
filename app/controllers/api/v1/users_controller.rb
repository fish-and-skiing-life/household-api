# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      include Secured
      include Auth0Manager
      before_action :set_user, only: %i[show update destroy]

      def callback
        render json: { path: "/#{@user.id}" }, status: :ok
      end

      def name_update
        @user = User.find(params['user']['id'])
        logger.debug('-check---------------------------')
        @user.update_name(params['user'])
        logger.debug('-check---------------------------')
        render json: { path: "/#{@user.name}" }, status: :ok
      end

      def check
        testlist = []
        logger.debug('-check---------------------------')
        user_hash = Hash.new([])
        logger.debug('-check---------------------------')
        logger.debug(@user.group_id)
        user_hash['group'] = @user.group_id
        logger.debug('-check---------------------------')
        logger.debug(testlist.push(@user))
        # u = user(@user.sub)
        logger.debug('-check---------------------------')
        # user_hash['name'] = u["name"]
        logger.debug('-check---------------------------')
        logger.debug(user_hash)
        
        render json: { user: @user}, status: :ok
      end

      def index
        logger.debug(@user)
        users = User.where(id: @user.id)
        user_id_hash =users.inject({}){|hash, u| hash[u.sub] = u.id;hash;}
        user_hash = users.inject({}){|hash, u| hash[u.sub] = u.role;hash;}
        query = users.inject([]){|arr,u| arr << u.sub}.join(" OR ")
        @params = {
          q: query,
          fields: 'id,email,user_id,name,logins_count,last_login,picture,created_at',
          include_fields: true,
          page: 0,
          per_page: 50
        }
        @users = auth0_client.users @params
        @users = @users.each{|u| u["id"] = user_id_hash[u["user_id"]] }
        testlist = []
        render status: :ok, json: @users
      end

      def show
        render json: @user, status: :ok
      end

      def create
        logger.debug('-check---------------------------')
        @params = {
          email: params[:email],
          password: params[:password],
          connection: ENV['AUTH0_CONNECTION'],
        }
        
        user = auth0_client.create_user(params[:name], @params) 
        @user = User.create_user(user) 
        render json: user, status: :ok
      end

      def update
        if @user.update_group(params[:group_id])
            render json: @user, status: :ok
        else
            render json: {"message": "admin user"}, status: :unprocessable_entity
        end
      end

      def delete
        user_id = params[:sub]
        auth0_client.delete_user(user_id) 
        @user = User.delete_user(user_id) 
        render json: @user, status: :ok
      end

      private
      def set_user
        @user = User.find_by(sub: params[:sub])
        render status: :no_content unless @user 
      end

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
  end
end
