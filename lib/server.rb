# frozen_string_literal: true

module Server
  module_function

  def start
    poller = MessageBus.queue_poller(ENV['SQS_QUEUE_NAME'])
    Application.logger.info("=============Listening in #{Application.env}===============")
    init_polling(poller)
  rescue Interrupt
    Application.logger.error('Stopping Server')
    exit
  end

  def init_polling(poller)
    poller.poll(max_number_of_messages: 10) do |messages|
      messages.each do |message|
        Thread.new do
          process_job(message)
        end
      end
    end
  end

  def process_job(sqs_message)
    # rubocop:disable Style/RescueModifier
    body = JSON.parse(sqs_message.body) rescue {}
    # rubocop:enable Style/RescueModifier

    case body['job_type']
    when 'notify_users'
      UserNotifyWorker.new(body['job_params'], sqs_message.message_id).perform
    else
      Application.logger.info("Please add worker to process job id: #{sqs_message.message_id}")
    end
  end
end
