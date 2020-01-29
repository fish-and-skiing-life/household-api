
module Api
  module V1
    class HouseholdController < ApplicationController
      include Secured
      before_action :set_expense, only: %i[show update destroy]

      def index
        render json: Household.list(@user.id)
      end

      def list_by_expense
        render json: Household.list_by_expense(params[:expense_id])
      end

      def list_period
        started_at = params[:started_at].split('/')
        ended_at = params[:ended_at].split('/')
        started_at = Time.local(started_at[0], started_at[1], started_at[2])
        ended_at = Time.local(ended_at[0], ended_at[1], ended_at[2])
        render json: Household.list_period(started_at, ended_at)
      end

      def show
        render json: @household 
      end

      def create

        household = Household.create_household(params[:household])
        render json: { status: :ok, message: 'loaded the review', data: household}
      end

      def update
        testlist = []
        logger.debug(testlist.push(@household))
        household = @household.update_household(params[:household])
        render json: {status: :ok, data: household}
      end

      def destroy
        Household.delete_household(@household.id)
      end

      private
      def set_expense
        @household = Household.find(params[:id])
        render status: :no_content unless @household
      end

    end
  end
end


