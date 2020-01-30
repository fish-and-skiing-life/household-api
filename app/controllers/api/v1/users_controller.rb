# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      include Secured
      include Auth0Manager

      def callback
        render json: { path: "/#{@user.id}" }, status: :ok
      end

      def check        
        render json: { user: @user}, status: :ok
      end

      def name_update
        user = @user.update_user(params[:user])
        render json: { path: "/#{@user.id}" }, status: :ok
      end

      def index
        render status: :ok, json: @user
      end

      def show
        user_hash = Hash.new([])
        user_hash['name'] = @user.name
        user_hash['created_at'] = @user.created_at
        if @user.group_token != nil then
          group = Group.find_by(group_token: @user.group_token)
          user_hash['group_token'] = @user.group_token
          user_hash['group_name'] = group.name
          user_hash['group_created_at'] = group.created_at
        else
          user_hash['group_token'] = nil
          user_hash['group_name'] =  nil
          user_hash['group_name'] = nil
        end
        render json: user_hash, status: :ok
      end

      def create
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
        user = @user.update_user(params[:user])
        render json: {status: :ok, data: user}
      end

      def attend_group
        group = Group.find_by(group_token: params[:group_token])
        if group == nil 
          render json: { error: 'not_found'}, status: :not_found
        end
        user = @user.update_group(params[:group_token])
        begin
          households = Household.find_by(user_id: @user.id)
          households.each do |household|
            household.update_group(params[:group_token])
          end
          expenses = Expense.find_by(user_id: @user.id)
          expenses.each do |expense|
            expense.update_group(params[:group_token])
          end
        rescue Exception => e
          
        end
        
        render json: {status: :ok, data: user}
      end

      def delete
        user_id = params[:sub]
        auth0_client.delete_user(user_id) 
        @user = User.delete_user(user_id) 
        render json: @user, status: :ok
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
  end
end
