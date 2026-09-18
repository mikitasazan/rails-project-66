# frozen_string_literal: true

module ApplicationHelper
  include AuthConcern

  def alert_classes(type)
    case type.to_s
    when "success", "notice"
      "bg-green-50 text-green-700"
    when "error", "alert"
      "bg-red-50 text-red-700"
    else
      "bg-blue-50 text-blue-700"
    end
  end

  def link_to_commit_id(check)
    commit_url = "https://github.com/#{check.repository.full_name}/commit/#{check.commit_id}"

    link_to check.commit_id, commit_url, class: "text-blue-600 hover:underline", target: "_blank", rel: "noopener"
  end
end
