require "./converters"

module Cord::Discord
  struct Emoji
    JSON.mapping({
      id:             {type: UInt64?, emit_null: true, converter: NilableSnowflakeConverter, setter: false},
      name:           {type: String, setter: false},
      roles:          {type: Array(UInt64)?, converter: NilableSnowflakeArrayConverter, setter: false},
      user:           {type: User?, setter: false},
      require_colons: {type: Bool?, setter: false},
      managed:        {type: Bool?, setter: false},
      animated:       {type: Bool?, setter: false},
    })
  end
end
