class Twig

  # Stores a branch's last commit time and its relative time representation.
  class CommitTime
    SECONDS_PER_YEAR   = 60 * 60 * 24 * 365
    SECONDS_PER_WEEK   = 60 * 60 * 24 * 7
    SECONDS_PER_DAY    = 60 * 60 * 24
    SECONDS_PER_HOUR   = 60 * 60
    SECONDS_PER_MINUTE = 60

    def self.now
      Time.now
    end

    def initialize(time)
      @time  = time
      now    = CommitTime.now
      suffix = @time > now ? 'from now' : 'ago'

      # For speed, lazily evaluate each `ago` computation
      @time_ago =
        if (years_ago = count_relative_years(now).abs) > 0
          "#{years_ago}y"
        elsif (months_ago = count_relative_months(now).abs) > 0 && (weeks_ago = count_relative_weeks(now).abs) > 4
          "#{months_ago}mo"
        elsif (weeks_ago ||= count_relative_weeks(now).abs) > 0
          "#{weeks_ago}w"
        elsif (days_ago = count_relative_days(now).abs) > 0
          "#{days_ago}d"
        elsif (hours_ago = count_relative_hours(now).abs) > 0
          "#{hours_ago}h"
        elsif (minutes_ago = count_relative_minutes(now).abs) > 0
          "#{minutes_ago}m"
        else
          seconds_ago = count_relative_seconds(now).abs
          "#{seconds_ago}s"
        end
      @time_ago << ' ' << suffix
    end

    def count_relative_years(current_time)
      seconds = @time - current_time
      seconds.abs < SECONDS_PER_YEAR ? 0 : (seconds / SECONDS_PER_YEAR).round
    end

    def count_relative_months(current_time)
      now = current_time
      (@time.year * 12 + @time.month) - (now.year * 12 + now.month)
    end

    def count_relative_weeks(current_time)
      seconds = @time - current_time
      seconds.abs < SECONDS_PER_WEEK ? 0 : (seconds / SECONDS_PER_WEEK).round
    end

    def count_relative_days(current_time)
      seconds = @time - current_time
      seconds.abs < SECONDS_PER_DAY ? 0 : (seconds / SECONDS_PER_DAY).round
    end

    def count_relative_hours(current_time)
      seconds = @time - current_time
      seconds.abs < SECONDS_PER_HOUR ? 0 : (seconds / SECONDS_PER_HOUR).round
    end

    def count_relative_minutes(current_time)
      seconds = @time - current_time
      seconds.abs < SECONDS_PER_MINUTE ? 0 : (seconds / SECONDS_PER_MINUTE).round
    end

    def count_relative_seconds(current_time)
      (@time - current_time).to_i
    end

    def to_i
      @time.to_i
    end

    def to_s
      time_string = @time.strftime('%F %R %z')
      "#{time_string} (#{@time_ago})"
    end

    def iso8601
      @time.iso8601
    end

    def <=>(other)
      to_i <=> other.to_i
    end
  end
end
