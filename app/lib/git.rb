# frozen_string_literal: true

class Git
  class << self
    def clone(clone_url, path_to_clone)
      system("git clone #{clone_url} #{path_to_clone}")
    end
  end
end
