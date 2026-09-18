# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthConcern
  include FlashConcern

  allow_browser versions: :modern
end
