# frozen_string_literal: true

require 'aws-sdk-sqs'

class MessageBus
  class << self
    def queue_poller(queue_name)
      begin
        queue_url = client.get_queue_url(queue_name: queue_name).queue_url
      rescue Aws::SQS::Errors::NonExistentQueue
        client.create_queue({ queue_name: queue_name })
        queue_url = client.get_queue_url(queue_name: queue_name).queue_url
      rescue Seahorse::Client::NetworkingError
        puts "Failed to open TCP connection to #{ENV['SQS_ENDPOINT']}"
        exit
      end
      Aws::SQS::QueuePoller.new(queue_url)
    end

    private

    def client
      @client ||= Aws::SQS::Client.new(endpoint: ENV['SQS_ENDPOINT'], region: ENV['AWS_REGION'])
    end
  end
end
