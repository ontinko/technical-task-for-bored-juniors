#!/bin/ruby

# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'

require_relative 'cli_parser'

class Caller
  BASE_URI = 'https://www.boredapi.com/api/activity/'
  PERMITTED_ARGS_NEW = %i[type participants price_min price_max accessibility-min accessibility_max].freeze

  def initialize(args)
    @args = args
    @query = build_query
  end

  def call
    query = @query.empty? ? '' : "?#{@query}"
    final_uri = URI("#{BASE_URI}#{query}")
    response = Net::HTTP.get_response(final_uri)
    puts "Response: #{response.body}"
  end

  private

  def build_query
    @args.map { |key, value| "#{transform_key(key)}=#{value}" }.join('&')
  end

  def transform_key(key)
    {
      type: 'type',
      participants: 'participants',
      price_min: 'minprice',
      price_max: 'maxprice',
      accessibility_min: 'minaccessibility',
      accessibility_max: 'maxaccessibility'
    }[key]
  end
end

def main
  cli_parser = CliParser.new(ARGV)
  cli_parser.call

  return puts cli_parser.error if cli_parser.failure

  case cli_parser.command
  when :new then Caller.new(cli_parser.args).call
  when :list then puts 'Listing all the things to be listed *brrrrrrrrr*'
  end
end

main
