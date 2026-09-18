# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  enumerize :language, in: %i[javascript ruby]

  belongs_to :user

  validates :github_id, presence: true

  has_many :checks, dependent: :destroy

  def display_name
    full_name || name || "-"
  end

  def path_to_directory
    File.join(Dir.tmpdir, "hexlet_quality_repositories/", full_name)
  end
end
