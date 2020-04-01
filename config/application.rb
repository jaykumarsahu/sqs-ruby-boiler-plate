# frozen_string_literal: true

require_relative 'environment'
require 'active_record'

class Application
  class << self
    def env
      @env ||= ActiveSupport::StringInquirer.new(ENV['CURRENT_ENV'].to_s.downcase)
    end

    def root
      @root ||= Pathname.new(Dir.pwd)
    end

    def logger
      return @logger unless @logger.nil?

      @logger = Logging.logger["RUBY SQS BOILER PLATE APP -- QUEUE: #{ENV['SQS_QUEUE_NAME']}"]
      @logger.level = env.development? ? :debug : :info
      @logger.add_appenders(
        Logging.appenders.stdout,
        Logging.appenders.file(root.join('log', "#{ENV['CURRENT_ENV']}.log"))
      )
      @logger
    end
  end
end

require_relative 'boot'
