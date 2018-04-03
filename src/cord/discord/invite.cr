require "./converters"

module Cord::Discord
  struct Invite
    JSON.mapping({
      code:                       {type: String, setter: false},
      guild:                      {type: Guild, setter: false},   # partial
      channel:                    {type: Channel, setter: false}, # partial
      approximate_presence_count: {type: Int32?, setter: false},
      approximate_member_count:   {type: Int32?, setter: false},
    })
  end

  struct InviteMetadata
    JSON.mapping({
      inviter:    {type: User, setter: false},
      uses:       {type: Int32, setter: false},
      max_uses:   {type: Int32, setter: false},
      max_age:    {type: Int32, setter: false},
      temporary:  {type: Bool, setter: false},
      created_at: {type: Time, converter: TimestampConverter, setter: false},
      revoked:    {type: Bool, setter: false},
    })
  end
end
