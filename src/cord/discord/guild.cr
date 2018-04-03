require "./converters"

module Cord::Discord
  struct Guild
    JSON.mapping({
      id:                            {type: UInt64, converter: SnowflakeConverter, setter: false},
      name:                          {type: String?, setter: false}, # always when available
      icon:                          {type: String?, emit_null: true, setter: false},
      splash:                        {type: String?, emit_null: true, setter: false},
      owner:                         {type: Bool?, setter: false},
      owner_id:                      {type: UInt64?, converter: NilableSnowflakeConverter, setter: false}, # always when available
      permissions:                   {type: Int32?, setter: false},
      region:                        {type: String?, setter: false}, # always when availbale
      afk_channel_id:                {type: UInt64?, converter: NilableSnowflakeConverter, setter: false},
      afk_timeout:                   {type: Int32?, setter: false}, # always when available
      embed_enabled:                 {type: Bool?, setter: false},
      embed_channel_id:              {type: UInt64?, converter: NilableSnowflakeConverter, setter: false},
      verification_level:            {type: VerificationLevel?, setter: false},                # always when available
      default_message_notifications: {type: DefaultMessageNotificationsLevel?, setter: false}, # always when available
      explicit_content_filter:       {type: ExplicitContentFilterLevel?, setter: false},       # always when available
      roles:                         {type: Array(Role)?, setter: false},                      # always when available
      emojis:                        {type: Array(Emoji)?, setter: false},                     # always when available
      features:                      {type: Array(String)?, setter: false},                    # always when available
      mfa_level:                     {type: MFALevel?, setter: false},                         # always when available
      application_id:                {type: UInt64?, converter: NilableSnowflakeConverter, setter: false},
      widget_enabled:                {type: Bool?, setter: false},
      widget_channel_id:             {type: UInt64?, converter: NilableSnowflakeConverter, setter: false},
      system_channel_id:             {type: UInt64?, emit_null: true, converter: NilableSnowflakeConverter, setter: false},

      # GUILD_CREATE only
      joined_at:    {type: Time?, converter: NilableTimestampConverter, setter: false},
      large:        {type: Bool?, setter: false},
      unavailable:  {type: Bool?, setter: false},
      member_count: {type: Int32?, setter: false},
      voice_states: {type: Array(VoiceState)?, setter: false},
      members:      {type: Array(GuildMember)?, setter: false},
      channels:     {type: Array(Channel)?, setter: false},
      presences:    {type: Array(PresenceUpdate)?, setter: false},
    })
  end

  enum VerificationLevel
    None
    Low
    Medium
    High
    VeryHigh
  end

  enum DefaultMessageNotificationsLevel
    AllMessages
    OnlyMentions
  end

  enum ExplicitContentFilterLevel
    Disabled
    MembersWithoutRoles
    AllMembers
  end

  enum MFALevel
    None
    Elevated
  end

  struct GuildEmbed
    JSON.mapping({
      enabled:    {type: Bool, setter: false},
      channel_id: {type: UInt64?, converter: NilableSnowflakeConverter, setter: false},
    })
  end

  struct GuildMember
    JSON.mapping({
      user:      {type: User, setter: false},
      nick:      {type: String?, setter: false},
      roles:     {type: Array(UInt64), converter: SnowflakeArrayConverter, setter: false},
      joined_at: {type: Time, converter: TimestampConverter, setter: false},
      deaf:      {type: Bool, setter: false},
      mute:      {type: Bool, setter: false},
    })
  end

  struct Integration
    # all fields present unless "partial"

    JSON.mapping({
      id:                  {type: UInt64?, converter: SnowflakeConverter, setter: false},
      name:                {type: String?, setter: false},
      type:                {type: String?, setter: false},
      enabled:             {type: Bool?, setter: false},
      syncing:             {type: Bool?, setter: false},
      role_id:             {type: UInt64?, converter: SnowflakeConverter, setter: false},
      expire_behavior:     {type: Int32?, setter: false},
      expire_grace_period: {type: Int32?, setter: false},
      user:                {type: User?, setter: false},
      account:             {type: IntegrationAccount?, setter: false},
      synced_at:           {type: Time?, converter: TimestampConverter, setter: false},
    })
  end

  struct IntegrationAccount
    JSON.mapping({
      id:   {type: String, setter: false},
      name: {type: String, setter: false},
    })
  end

  struct Ban
    JSON.mapping({
      reason: {type: String?, setter: false},
      user:   {type: User, setter: false},
    })
  end

  struct Role
    JSON.mapping({
      id:          {type: UInt64, converter: SnowflakeConverter, setter: false},
      name:        {type: String, setter: false},
      color:       {type: Int32, setter: false},
      hoist:       {type: Bool, setter: false},
      position:    {type: Int32, setter: false},
      permissions: {type: Int32, setter: false},
      managed:     {type: Bool, setter: false},
      mentionable: {type: Bool, setter: false},
    })
  end
end
