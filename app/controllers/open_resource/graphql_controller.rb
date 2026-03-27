# frozen_string_literal: true

module OpenResource
  class GraphqlController < ApplicationController
    # POST /graphql
    def execute
      result = GraphqlSchemaFactory.schema.execute(
        params[:query],
        variables:      prepare_variables(params[:variables]),
        context:        build_context,
        operation_name: params[:operationName]
      )
      render json: result
    rescue StandardError => e
      raise e unless Rails.env.development?

      handle_error_in_development(e)
    end

    private

    def build_context
      { request: request }
    end

    # Handle variables that may arrive as a JSON string, a Hash, or blank.
    def prepare_variables(variables_param)
      case variables_param
      when String
        variables_param.present? ? JSON.parse(variables_param) : {}
      when Hash
        variables_param
      when ActionController::Parameters
        variables_param.to_unsafe_h
      else
        {}
      end
    end

    def handle_error_in_development(error)
      logger.error error.message
      logger.error error.backtrace.join("\n")

      render json: {
        errors: [{ message: error.message, backtrace: error.backtrace.first(5) }],
        data: {}
      }, status: :internal_server_error
    end
  end
end
