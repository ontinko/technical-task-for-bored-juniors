# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'

class ApiCaller
  attr_reader :failure, :activity

  BASE_URI = 'https://www.boredapi.com/api/activity/'

  def initialize(args)
    @args = args
    @activity = nil
    @failure = false
    @message = ''
  end

  def call
    query_string = @args.empty? ? '' : "?#{build_query}"
    final_uri = URI("#{BASE_URI}#{query_string}")
    response = Net::HTTP.get_response(final_uri)
    return handle_error('Failed request') if error_in_body?(response.body) || response.code != '200'

    @activity = JSON.parse(response.body)

    self
  end

  def error
    puts "Error: #{@message}"
  end

  private

  def build_query
    @args.map { |key, value| "#{key}=#{value}" }.join('&')
  end

  def handle_error(message)
    @failure = true
    @message = message
  end

  def error_in_body?(body)
    JSON.parse(body).keys[0] == 'error'
  end
end
