# frozen_string_literal: true

#
# Main mailer class
#
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
