require 'securerandom'
module Api
  module V1
    class GroupController < ApplicationController
      include Secured
      before_action :set_group, only: %i[show update destroy]

      def index
        render json: Group.all
      end

      def show
        render json: @group 
      end

      def create
        token =  SecureRandom.hex(8)
        group = Group.create_group(params[:group], token)
        @user.update_group(token)
        render json: { status: :ok, message: 'loaded the review', data: group}
      end

      def update
        group = @group.update_group(params[:group])
        render json: {status: :ok, data: group}
      end

      def destroy
        users = User.where(group_token: params[:id])
        users.each do |u|
          u.update_group(nil)
        end
        Group.delete_group(@group.id)
      end

      private
      def set_group 
        @group = Group.find_by(group_token: params[:id])
        if @group == nil 
          render json: { error: 'not_found'}, status: :not_found

        end
      end

    end
  end
end


