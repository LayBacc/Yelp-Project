module Api
  module V1
    class FeedbacksController < ApplicationController
      respond_to :json

      def create
        Feedback.create(body: feedback_params[:body])
        render json: { status: 'OK' }
      end

      private

      def feedback_params
        params.require(:feedback).permit(:body)
      end
    end
  end
end
