class ApplicationJob < ActiveJob::Base
  sidekiq_options retry: 0, backtrace: true
end
