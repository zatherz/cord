require "./converters"
require "./guild"
require "./channel"

module Cord::Discord
  struct AuditLog
    JSON.mapping({
      webhooks:          {type: Array(Webhook), setter: false},
      users:             {type: Array(User), setter: false},
      audit_log_entries: {type: Array(AuditLogEntry), setter: false},
    })
  end

  struct AuditLogEntry
    JSON.mapping({
      target_id:   {type: String?, setter: false, emit_null: true},
      changes:     {type: Array(AuditLogChange)?, setter: false},
      user_id:     {type: UInt64, converter: SnowflakeConverter, setter: false},
      id:          {type: UInt64, converter: SnowflakeConverter, setter: false},
      action_type: {type: AuditLogEvent, setter: false},
      options:     {type: OptionalAuditEntryInfo?, setter: false},
      reason:      {type: String?, setter: false},
    })
  end

  enum AuditLogEvent
    GuildUpdate            =  1
    ChannelCreate          = 10
    ChannelUpdate
    ChannelDelete
    ChannelOverwriteCreate
    ChannelOverwriteUpdate
    ChannelOverwriteDelete
    MemberKick             = 20
    MemberPrune
    MemberBanAdd
    MemberBanRemove
    MemberUpdate
    MemberRoleUpdate
    RoleCreate             = 30
    RoleUpdate
    RoleDelete
    InviteCreate           = 40
    InviteUpdate
    InviteDelete
    WebhookCreate          = 50
    WebhookUpdate
    WebhookDelete
    EmojiCreate            = 60
    EmojiUpdate
    EmojiDelete
    MessageDelete          = 72
  end

  struct OptionalAuditEntryInfo
    JSON.mapping({
      delete_member_days: {type: String?, setter: false},                                       # MemberPrune
      members_removed:    {type: String?, setter: false},                                       # MemberPrune
      channel_id:         {type: UInt64?, converter: NilableSnowflakeConverter, setter: false}, # MemberDelete
      count:              {type: String?, setter: false},                                       # MessageDelete
      id:                 {type: UInt64?, converter: NilableSnowflakeConverter, setter: false}, # ChannelOverwrite*
      type:               {type: String?, setter: false},                                       # ChannelOverwrite*, valid values: "member" and "role"
      role_name:          {type: String?, setter: false},                                       # ChannelOverwrite*, only when type = "role"
    })
  end

  struct AuditLogChange
    # SNOWFLAKES NOT AUTOCONVERTED!!!
    alias ValueType = String | Int32 | Array(Role) | Bool | Array(Overwrite)

    JSON.mapping({
      new_value: {type: ValueType?, setter: false},
      old_value: {type: ValueType?, setter: false},
      key:       {type: String, setter: false},
    })
  end
end
