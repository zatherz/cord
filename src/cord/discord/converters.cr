module Cord::Discord
  module SnowflakeConverter
    def self.from_json(parser : JSON::PullParser) : UInt64
      parser.read_string.to_u64
    end

    def self.to_json(value : UInt64, builder : JSON::Builder)
      builder.scalar value.to_s
    end
  end

  module NilableSnowflakeConverter
    def self.from_json(parser : JSON::PullParser) : UInt64?
      parser.read_string_or_null.try &.to_u64
    end

    def self.to_json(value : UInt64?, builder : JSON::Builder)
      if value
        builder.scalar value.to_s
      else
        builder.null
      end
    end
  end

  module SnowflakeArrayConverter
    def self.from_json(parser : JSON::PullParser) : Array(UInt64)
      Array(String).new(parser).map &.to_u64
    end

    def self.to_json(value : Array(UInt64), builder : JSON::Builder)
      value.map(&.to_s).to_json builder
    end
  end

  module NilableSnowflakeArrayConverter
    def self.from_json(parser : JSON::PullParser) : Array(UInt64)
      parser.read_null_or { Array(String).new(parser).map &.to_u64 }
    end

    def self.to_json(value : Array(UInt64)?, builder : JSON::Builder)
      if value
        value.map(&.to_s).to_json builder
      else
        builder.null
      end
    end
  end

  module TriBoolConverter # nil => false
    def self.from_json(parser : JSON::PullParser) : Array(UInt64)
      val = parser.read_bool_or_null || false
    end

    def self.to_json(value : Bool, builder : JSON::Builder)
      builder.scalar val
    end
  end

  # shamelessly stolen from discordcr

  module TimestampConverter
    def self.from_json(parser : JSON::PullParser) : Time
      time_str = parser.read_string

      begin
        Time::Format.new("%FT%T.%L%:z", Time::Kind::Utc).parse(time_str)
      rescue Time::Format::Error
        Time::Format.new("%FT%T%:z", Time::Kind::Utc).parse(time_str)
      end
    end
  end

  module NilableTimestampConverter
    def self.from_json(parser : JSON::PullParser) : Time?
      parser.read_null_or do
        time_str = parser.read_string

        begin
          Time::Format.new("%FT%T.%L%:z", Time::Kind::Utc).parse(time_str)
        rescue Time::Format::Error
          Time::Format.new("%FT%T%:z", Time::Kind::Utc).parse(time_str)
        end
      end
    end
  end

  module MillisecondEpochConverter
    def self.from_json(parser : JSON::PullParser) : Time
      Time.epoch_ms(parser.read_int)
    end

    def self.to_json(value : Time, builder : JSON::Builder)
      builder.scalar value
    end
  end

  module NilableMillisecondEpochConverter
    def self.from_json(parser : JSON::PullParser) : Time?
      parser.read_null_or { Time.epoch_ms(parser.read_int) }
    end

    def self.to_json(value : Time, builder : JSON::Builder)
      if value
        builder.scalar value
      else
        builder.null
      end
    end
  end
end
