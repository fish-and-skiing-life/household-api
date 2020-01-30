require 'securerandom'
module Api
  module V1
    class GroupController < ApplicationController
      include Secured
      before_action :set_group, only: %i[show update destroy]

      def index
        render json: Group.list(@user.id)
      end

      def show
        render json: @group 
      end

      def create
        token =  SecureRandom.hex(8)
        group = Group.create_group(params[:group], token)
        @user.update_group(token)
        begin
          households = Household.find_by(user_id: @user.id)
          households.each do |household|
            household.update_group(token)
          end
          expenses = Expense.find_by(user_id: @user.id)
          expenses.each do |expense|
            expense.update_group(token)
          end
        rescue Exception => e
          
        end
        
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
          begin
            households = Household.find_by(user_id: u.id)
            households.each do |household|
              household.update_group(nil)
            end
            expenses = Expense.find_by(user_id: u.id)
            expenses.each do |expense|
              expense.update_group(nil)
            end
          rescue Exception => e
            
          end
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


