# frozen_string_literal: true

class BaseWorker
  attr_reader :params, :job_id

  def initialize(params, job_id)
    @params = params
    @job_id = job_id
  end

  private

  def log_message
    Application.logger.info("====Message id: #{job_id} started")
    yield
    Application.logger.info("====Message id: #{job_id} done")
  end
end
