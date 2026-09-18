# frozen_string_literal: true

class CheckResultMailer < ApplicationMailer
  default from: "from@example.com"

  def passed_check_email
    @check = params[:check]

    mail to: email_to, subject: t(".subject", full_name: @check.repository.full_name)
  end

  def failed_check_email
    @check = params[:check]

    mail to: email_to, subject: t(".subject", full_name: @check.repository.full_name)
  end

  def error_check_email
    @check = params[:check]

    mail to: email_to, subject: t(".subject", full_name: @check.repository.full_name)
  end

  private

  def email_to
    params[:user].email
  end
end
