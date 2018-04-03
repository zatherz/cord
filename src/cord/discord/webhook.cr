require "./converters"

module Cord::Discord
  struct Webhook
    JSON.mapping({
      id:         {type: UInt64, converter: SnowflakeConverter, setter: false},
      guild_id:   {type: UInt64?, converter: NilableSnowflakeConverter, setter: false},
      channel_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
      user:       {type: User?, setter: false},
      name:       {type: String?, emit_null: true, setter: false},
      avatar:     {type: String?, emit_null: true, setter: false},
      token:      {type: String, setter: false},
    })
  end
end
