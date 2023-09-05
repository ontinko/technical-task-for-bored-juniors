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
    query_string = @args.empty? ? '' : "?#{build_query}"
    final_uri = URI("#{BASE_URI}#{query_string}")
    response = Net::HTTP.get_response(final_uri)
    return handle_error('Failed request') if error_in_body?(response.body) || response.code != '200'

    @activity = JSON.parse(response.body)
  rescue SocketError
    handle_error('No connection')
  end

  private

  def build_query
    @args.map { |key, value| "#{key}=#{value}" }.join('&')
  end

  def handle_error(message)
    raise ApplicationError, message
  end

  def error_in_body?(body)
    JSON.parse(body).keys[0] == 'error'
  end
end
