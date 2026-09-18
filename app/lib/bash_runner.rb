# frozen_string_literal: true

class BashRunner
  class << self
    def execute(command)
      output = `#{command}`
      [ output, $CHILD_STATUS.exitstatus ]
    end
  end
end
