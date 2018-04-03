require "./converters"

module Cord::Discord
  struct User
    JSON.mapping({
      id:            {type: UInt64, converter: SnowflakeConverter, setter: false},
      username:      {type: String, setter: false},
      discriminator: {type: String, setter: false},
      avatar:        {type: String?, emit_null: true, setter: false},
      bot:           {type: Bool?, setter: false},
      mfa_enabled:   {type: Bool?, setter: false},
      verified:      {type: Bool?, setter: false},
      email:         {type: String?, setter: false},
    })
  end

  struct Connection
    JSON.mapping({
      id:           {type: String, setter: false},
      name:         {type: String, setter: false},
      type:         {type: String, setter: false}, # twitch, youtube etc
      revoked:      {type: Bool, setter: false},
      integrations: {type: Array(Integration), setter: false},
    })
  end
end
