
module Api
  module V1
    class GroupIndexController < ApplicationController
      protect_from_forgery 
      include Secured
      before_action :set_group, only: %i[show update destroy]

      def index
        render json: Group.all
      end

      def show
        render json: @group 
      end

      def create
        group = Group.create_group(params[:group])
        render json: { status: :ok, message: 'loaded the review', data: group}
      end

      def update
        group = @group.update_group(params[:group])
        render json: {status: :ok, data: group}
      end

      def destroy
        Group.delete_group(@group.id)
      end

      private
      def set_group 
        @group = Group.find(params[:id])
        render status: :no_content unless @group
      end

    end
  end
end


