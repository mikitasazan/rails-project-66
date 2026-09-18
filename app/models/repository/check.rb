# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository

  aasm column: :aasm_state do
    state :created, initial: true
    state :checking, :finished, :failed

    event :run_check do
      transitions from: :created, to: :checking
    end

    event :mark_as_finish do
      transitions from: :checking, to: :finished
    end

    event :mark_as_fail do
      transitions from: :checking, to: :failed
    end
  end
end
