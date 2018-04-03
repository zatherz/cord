require "./converters"

module Cord::Discord
  struct VoiceState
    JSON.mapping({
      guild_id:   {type: UInt64?, converter: NilableSnowflakeConverter, setter: false},
      channel_id: {type: UInt64?, emit_null: true, converter: NilableSnowflakeConverter, setter: false},
      user_id:    {type: UInt64, converter: SnowflakeConverter, setter: false},
      session_id: {type: String, setter: false},
      deaf:       {type: Bool, setter: false},
      mute:       {type: Bool, setter: false},
      self_deaf:  {type: Bool, setter: false},
      self_mute:  {type: Bool, setter: false},
      suppress:   {type: Bool, setter: false},
    })
  end

  struct VoiceRegion
    JSON.mapping({
      id:         {type: String, setter: false},
      name:       {type: String, setter: false},
      vip:        {type: Bool, setter: false},
      optimal:    {type: Bool, setter: false},
      deprecated: {type: Bool, setter: false},
      custom:     {type: Bool, setter: false},
    })
  end
end
