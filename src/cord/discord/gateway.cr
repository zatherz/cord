module Cord::Discord
  struct GatewayPacket
    @op : GatewayOp
    @d : IO::Memory
    @s : Int32? = nil
    @t : String? = nil

    def initialize(@op, @d, @s = nil, @t = nil)
    end

    def initialize(parser : JSON::PullParser)
      @op = GatewayOp
      @d = IO::Memory.new
      @t = nil
      @s = nil

      parser.read_object do |key|
        case key
        when "op"
          opcode = parser.read_int
        when "d"
          JSON.build(data) { |builder| parser.read_raw builder }
        when "s"
          sequence = parser.read_int_or_null
        when "t"
          event_type = parser.read_string_or_null
        else
          raise "UNKNOWN GATEWAY PACKET FIELD: #{key}"
        end
      end

      data.rewind

      self.new(opcode, sequence, data, event_type)
    end
  end

  enum GatewayOp
    Dispatch
    Heartbeat
    Identify
    StatusUpdate
    VoiceStateUpdate
    VoiceServerPing
    Resume
    Reconnect
    RequestGuildMembers
    InvalidSession
    Hello
    HeartbeatACK
  end

  enum GatewayCloseEvent
    UnknownError         = 4000
    UnknownOpcode        = 4001
    DecodeError          = 4002
    NotAuthenticated     = 4003
    AuthenticationFailed = 4004
    AlreadyAuthenticated = 4005
    InvalidSeq           = 4007
    RateLimited          = 4008
    SessionTimeout       = 4009
    InvalidShard         = 4010
    ShardingRequired     = 4011
  end

  enum VoiceOp
    Identify
    SelectProtocol
    Ready
    Heartbeat
    SessionDescription
    Speaking
    HeartbeatACK
    Resume
    Hello
    Resumed
    ClientDisconnect
  end

  enum VoiceCloseEvent
    UnknownOpcode         = 4001
    NotAuthenticated      = 4003
    AuthenticationFailed  = 4004
    AlreadyAuthenticated  = 4005
    SessionNoLongerValid  = 4006
    SessionTimeout        = 4009
    ServerNotFound        = 4011
    UnknownProtocol       = 4012
    Disconnected          = 4014
    VoiceServerCrashed    = 4015
    UnknownEncryptionMode = 4016
  end

  struct RESTError
    JSON.mapping({
      code:    {type: JSONError, setter: false},
      message: {type: String, setter: false},
    })
  end

  enum JSONError
    UnknownAccount     = 10001
    UnknownApplication
    UnknownChannel
    UnknownGuild
    UnknownIntegration
    UnknownInvite
    UnknownMember
    UnknownMessage
    UnknownOverwrite
    UnknownProvider
    UnknownRole
    UnknownToken
    UnknownUser
    UnknownEmoji

    BotsCannotUseThisEndpoint  = 20001
    OnlyBotsCanUseThisEndpoint

    MaxNumberOfGuildsReached        = 30001
    MaxNumberOfFriendsReached
    MaxNumberOfPinsReached
    MaxNumberOfGuildRolesReached    = 30005
    MaxNumberOfReactionsReached     = 30010
    MaxNumberOfGuildChannelsReached = 30013

    Unauthorized = 40001

    MissingAccess                          = 50001
    InvalidAccountType
    CannotExecuteActionOnDMChannel
    WidgetDisabled
    CannotEditMessageAuthoredByAnotherUser
    CannotSendEmptyMessage
    CannotSendMessageToThisUser
    CannotSendMessageInVoiceChannel
    ChannelVerificationLevelTooHigh
    OAuth2ApplicationDoesNotHaveBot
    OAuth2ApplicationLimitReached
    InvalidOAuthState
    MissingPermissions
    InvalidAuthenticationToken
    NoteIsTooLong
    TooFewOrTooManyMessagesToDelete
    MessageCantBePinnedInDifferentChannel  = 50019
    CannotExecuteActionOnSystemMessage     = 50021
    MessageTooOldToBulkDelete              = 50034
    InvalidFormBody                        = 50035
    InviteAcceptedToGuildBotIsNotIn
    InvalidAPIVersion                      = 50041

    ReactionBlocked = 90001
  end

  alias GatewayShardID = Tuple(Int32, Int32)

  struct GatewayIdentifyData
    JSON.mapping({
      token:           {type: String, setter: false},
      properties:      {type: GatewayConnectionProperties, setter: false},
      compress:        {type: Bool?, setter: false},
      large_threshold: {type: Int32?, setter: false},
      shard:           {type: GatewayShardID?, setter: false},
      presence:        {type: PresenceUpdate?, setter: false},
    })
  end

  struct GatewayConnectionProperties
    JSON.mapping({
      os:      {type: String, key: "$os", setter: false},
      browser: {type: String, key: "$browser", setter: false},
      device:  {type: String, key: "$device", setter: false},
    })

    def initialize(@os, @browser, @device)
    end
  end

  struct GatewayResumeData
    JSON.mapping({
      token:      {type: String, setter: false},
      session_id: {type: String, setter: false},
      seq:        {type: Int32, setter: false},
    })
  end

  struct GatewayRequestGuildMembersData
    JSON.mapping({
      guild_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
      query:    {type: String, setter: false},
      limit:    {type: Int32, setter: false},
    })
  end

  struct GatewayUpdateVoiceStateData
    JSON.mapping({
      guild_id:   {type: UInt64, converter: SnowflakeConverter, setter: false},
      channel_id: {type: UInt64?, emit_null: true, converter: NilableSnowflakeConverter, setter: false},
      self_mute:  {type: Bool, setter: false},
      self_deaf:  {type: Bool, setter: false},
    })
  end

  struct GatewayUpdateStatusData
    JSON.mapping({
      since:  {type: Int32?, emit_null: true, setter: false},
      game:   {type: Activity?, emit_null: true, setter: false},
      status: {type: String, setter: false}, # "online", "dnd", "idle", "invisible", "offline"
      afk:    {type: Bool, setter: false},
    })
  end

  struct GatewayHelloEvent
    JSON.mapping({
      heartbeat_interval: {type: Int32, setter: false},
      _trace:             {type: Array(String), setter: false},
    })
  end

  struct GatewayReadyEvent
    JSON.mapping({
      v:                {type: Int32, setter: false},
      user:             {type: User, setter: false},
      private_channels: {type: Array(Channel), setter: false},
      guilds:           {type: Array(Guild), setter: false}, # always unavailable guilds
      session_id:       {type: String, setter: false},
      _trace:           {type: Array(String), setter: false},
    })
  end

  struct GatewayResumedEvent
    JSON.mapping({
      _trace: {type: Array(String), setter: false},
    })
  end

  # InvalidSession has no data

  alias GatewayChannelCreateEvent = Channel
  alias GatewayChannelUpdateEvent = Channel
  alias GatewayChannelDeleteEvent = Channel

  struct GatewayChannelPinsUpdateEvent
    JSON.mapping({
      channel_id:         {type: UInt64, converter: SnowflakeConverter, setter: false},
      last_pin_timestamp: {type: Time?, converter: NilableTimestampConverter, setter: false},
    })
  end

  alias GatewayGuildCreateEvent = Guild
  alias GatewayGuildUpdateEvent = Guild
  alias GatewayGuildDeleteEvent = Guild # if unavailable == nil, user was REMOVED from the guild

  alias GatewayGuildBanAddEvent = User # with the extra guild_id field
  alias GatewayGuildBanRemoveEvent = User

  struct GatewayGuildEmojisUpdateEvent
    JSON.mapping({
      guild_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
      emojis:   {type: Array(Emoji), setter: false},
    })
  end

  struct GatewayGuildIntegrationsUpdateEvent
    JSON.mapping({
      guild_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
    })
  end

  alias GatewayGuildMemberAddEvent = GuildMember

  struct GatewayGuildMemberRemoveEvent
    JSON.mapping({
      guild_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
      user:     {type: User, setter: false},
    })
  end

  struct GatewayGuildMemberUpdateEvent
    JSON.mapping({
      guild_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
      roles:    {type: Array(UInt64), converter: SnowflakeArrayConverter, setter: false},
      user:     {type: User, setter: false},
      nick:     {type: String?, setter: false}, # Suspected undocumented possible nil
    })
  end

  struct GatewayGuildMembersChunkEvent
    JSON.mapping({
      guild_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
      members:  {type: Array(GuildMember), setter: false},
    })
  end

  struct GatewayGuildRoleCreateEvent
    JSON.mapping({
      guild_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
      role:     {type: Role, setter: false},
    })
  end

  struct GatewayGuildRoleUpdateEvent
    JSON.mapping({
      guild_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
      role:     {type: Role, setter: false},
    })
  end

  struct GatewayGuildRoleDeleteEvent
    JSON.mapping({
      guild_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
      role_id:  {type: UInt64, converter: SnowflakeConverter, setter: false},
    })
  end

  alias GatewayMessageCreateEvent = Message
  alias GatewayMessageUpdateEvent = Message # partial
  struct GatewayMessageDeleteEvent
    JSON.mapping({
      id:         {type: UInt64, converter: SnowflakeConverter, setter: false},
      channel_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
    })
  end

  struct GatewayMessageDeleteBulkEvent
    JSON.mapping({
      ids:        {type: Array(UInt64), converter: SnowflakeArrayConverter, setter: false},
      channel_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
    })
  end

  struct GatewayMessageReactionAddEvent
    JSON.mapping({
      user_id:    {type: UInt64, converter: SnowflakeConverter, setter: false},
      channel_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
      message_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
      emoji:      {type: Emoji, setter: false}, # partial (reaction emoji)
    })
  end

  struct GatewayMessageReactionRemoveEvent
    JSON.mapping({
      user_id:    {type: UInt64, converter: SnowflakeConverter, setter: false},
      channel_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
      message_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
      emoji:      {type: Emoji, setter: false}, # partial (reaction emoji)
    })
  end

  struct GatewayMessageReactionRemoveAllEvent
    JSON.mapping({
      channel_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
      message_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
    })
  end

  struct PresenceUpdate
    JSON.mapping({
      user_id:  {type: UInt64, converter: SnowflakeConverter, root: "user", key: "id", setter: false},
      roles:    {type: Array(UInt64), converter: SnowflakeArrayConverter, setter: false},
      game:     {type: Activity?, setter: false},
      guild_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
      status:   {type: String, setter: false}, # "idle", "dnd", "online", "offline" (#TODO can you see "invisible" here? I think it just appears as "offline")
    })
  end

  struct Activity
    JSON.mapping({
      name:           {type: String, setter: false},
      type:           {type: ActivityType, setter: false},
      url:            {type: String?, setter: false},
      timestamps:     {type: ActivityTimestamps?, setter: false},
      application_id: {type: UInt64?, converter: NilableSnowflakeConverter, setter: false},
      details:        {type: String?, setter: false},
      state:          {type: String?, setter: false},
      party:          {type: ActivityParty?, setter: false},
      assets:         {type: ActivityAssets?, setter: false},
      secrets:        {type: ActivitySecrets?, setter: false},
      instance:       {type: Bool?, setter: false},
      flags:          {type: Int32?, setter: false},
    })
  end

  enum ActivityType
    Game
    Streaming
    Listening
  end

  struct ActivityTimestamps
    JSON.mapping({
      start: {type: Time?, converter: NilableMillisecondEpochConverter, setter: false},
      end:   {type: Time?, converter: NilableMillisecondEpochConverter, setter: false},
    })
  end

  alias ActivityPartySize = Tuple(Int32, Int32) # current_size, max_size

  struct ActivityParty
    JSON.mapping({
      id:   {type: String?, setter: false},
      size: {type: ActivityPartySize?, setter: false},
    })
  end

  struct ActivityAssets
    JSON.mapping({
      large_image: {type: String?, setter: false},
      large_text:  {type: String?, setter: false},
      small_image: {type: String?, setter: false},
      small_text:  {type: String?, setter: false},
    })
  end

  struct ActivitySecrets
    JSON.mapping({
      join:     {type: String?, setter: false},
      spectate: {type: String?, setter: false},
      match:    {type: String?, setter: false},
    })
  end

  @[Flags]
  enum ActivityFlags
    Instance    = 1 << 0
    Join        = 1 << 1
    Spectate    = 1 << 2
    JoinRequest = 1 << 3
    Sync        = 1 << 4
    Play        = 1 << 5
  end

  struct GatewayTypingStartEvent
    JSON.mapping({
      channel_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
      user_id:    {type: UInt64, converter: SnowflakeConverter, setter: false},
      timestamp:  {type: Time, converter: Time::EpochConverter, setter: false},
    })
  end

  alias GatewayUserUpdateEvent = User

  alias GatewayVoiceStateUpdateEvent = VoiceState

  struct GatewayVoiceServerUpdateEvent
    JSON.mapping({
      token:    {type: String, setter: false},
      guild_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
      endpoint: {type: String, setter: false},
    })
  end

  struct GatewayWebhooksUpdateEvent
    JSON.mapping({
      guild_id:   {type: UInt64, converter: SnowflakeConverter, setter: false},
      channel_id: {type: UInt64, converter: SnowflakeConverter, setter: false},
    })
  end
end
