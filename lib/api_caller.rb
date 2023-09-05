# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
require_relative 'errors/application_error'

class ApiCaller
  attr_reader :activity

  BASE_URI = 'https://www.boredapi.com/api/activity/'

  def initialize(args)
    @args = args
    @activity = nil
  end

  def call
    final_uri = URI("#{BASE_URI}#{query_string}")
    response = Net::HTTP.get_response(final_uri)
    return handle_error('Invalid request') if error_in_response?(response)

    @activity = JSON.parse(response.body)
  rescue SocketError
    handle_error('No connection')
  end

  private

  def error_in_response?(response)
    response.code != '200' ||
      response.body.empty? ||
      JSON.parse(response.body).keys.first == 'error'
  end

  def query_string
    return '' if @args.empty?

    "?#{@args.map { |key, value| "#{key}=#{value}" }.join('&')}"
  end

  def handle_error(message)
    raise ApplicationError, message
  end
end
