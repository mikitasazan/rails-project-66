# frozen_string_literal: true

class LogFormatter
  class << self
    def format(log, language)
      case language
      when "ruby"
        format_rubocop(log)
      when "javascript"
        format_eslint(log)
      else
        { offense_count: 0, files: [] }
      end
    end

    private

    def format_rubocop(log)
      summary = log.dig("summary", "offense_count") || 0

      files = log["files"].to_a.filter_map do |file|
        next if file["offenses"].empty?

        {
          path: file["path"],
          messages: file["offenses"].map { |o| "#{o['message']} (#{o['location']['line']}:#{o['location']['column']})" }
        }
      end

      { offense_count: summary, files: }
    end

    def format_eslint(log)
      offenses = log.to_a.sum { |file| file["errorCount"] + file["warningCount"] }

      files = log.to_a.filter_map do |file|
        next if file["messages"].empty?

        {
          path: file["filePath"],
          messages: file["messages"].map { |m| "#{m['message']} (#{m['line']}:#{m['column']})" }
        }
      end

      { offense_count: offenses, files: }
    end
  end
end
