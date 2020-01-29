
module Api
  module V1
    class ExpenseController < ApplicationController
      include Secured
      before_action :set_expense, only: %i[show update destroy]

      def index
        render json: Expense.list(@user.id)
      end

      def show
        render json: @expense 
      end

      def create
        expense = Expense.create_expense(params[:expense])
        render json: { status: :ok, message: 'loaded the review', data: expense}
      end

      def update
        expense = @expense.update_expense(params[:expense])
        render json: {status: :ok, data: expense}
      end

      def destroy
        testlist = []
        logger.debug(testlist.push(@expense))
        Expense.delete_expense(@expense.id)
      end

      private
      def set_expense
        @expense = Expense.find(params[:id])
        render status: :no_content unless @expense
      end

    end
  end
end


