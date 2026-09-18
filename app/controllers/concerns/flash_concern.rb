# frozen_string_literal: true

module FlashConcern
  def f(kind)
    flash[kind] = t(".#{kind}")
  end
end
