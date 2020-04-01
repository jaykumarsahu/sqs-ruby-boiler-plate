# frozen_string_literal: true

require 'bundler'

ENV_NAMES = %w[development production].freeze

if ENV_NAMES.include?(ENV['CURRENT_ENV'].to_s.downcase)
  Bundler.require(:default, ENV['CURRENT_ENV'].downcase.to_sym)
else
  puts 'Please specify correct env name'
  exit
end
