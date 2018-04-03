require "./converters"

module Cord::Discord
  struct Channel
    JSON.mapping({
      id:                    {type: UInt64, converter: SnowflakeConverter, setter: false},
      type:                  {type: ChannelType, setter: false},
      guild_id:              {type: UInt64?, converter: NilableSnowflakeConverter, setter: false},
      position:              {type: Int32?, setter: false},
      permission_overwrites: {type: Array(Overwrite)?, setter: false},
      name:                  {type: String?, setter: false},
      topic:                 {type: String?, setter: false},
      nsfw:                  {type: Bool?, setter: false},
      last_message_id:       {type: UInt64?, converter: NilableSnowflakeConverter, setter: false},
      bitrate:               {type: Int32?, setter: false},
      user_limit:            {type: Int32?, setter: false},
      recipients:            {type: Array(User)?, setter: false},
      icon:                  {type: String?, setter: false},
      owner_id:              {type: UInt64?, converter: NilableSnowflakeConverter, setter: false},
      application_id:        {type: UInt64?, converter: NilableSnowflakeConverter, setter: false},
      parent_id:             {type: UInt64?, converter: NilableSnowflakeConverter, setter: false},
      last_pin_timestamp:    {type: Time?, converter: TimestampConverter, setter: false},
    })
  end

  enum ChannelType
    GuildText
    DM
    GuildVoice
    GroupDM
    GuildCategory
  end

  struct Message
    JSON.mapping({
      id:               {type: UInt64, converter: SnowflakeConverter, setter: false},
      channel_id:       {type: UInt64, converter: SnowflakeConverter, setter: false},
      author:           {type: User, setter: false}, # watch out for webhook messages
      content:          {type: String, setter: false},
      timestamp:        {type: Time, converter: TimestampConverter, setter: false},
      edited_timestamp: {type: Time?, converter: NilableTimestampConverter, setter: false},
      tts:              {type: Bool, setter: false},
      mention_everyone: {type: Bool, setter: false},
      mentions:         {type: Array(User), setter: false},
      mention_roles:    {type: Array(Role), setter: false},
      attachments:      {type: Array(Attachment), setter: false},
      embeds:           {type: Array(Embed), setter: false},
      reactions:        {type: Array(Reaction)?, setter: false},
      nonce:            {type: UInt64?, converter: NilableSnowflakeConverter, setter: false},
      pinned:           {type: Bool, setter: false},
      webhook_id:       {type: UInt64?, converter: NilableSnowflakeConverter, setter: false},
      type:             {type: MessageType, setter: false},
      activity:         {type: MessageActivity?, setter: false},
      application:      {type: MessageApplication?, setter: false},
    })
  end

  enum MessageType
    Default
    RecipientAdd
    RecipientRemove
    Call
    ChannelNameChange
    ChannelIconChange
    ChannelPinnedMessage
    GuildMemberJoin
  end

  struct MessageActivity
    JSON.mapping({
      type:     {type: MessageActivityType, setter: false},
      party_id: {type: String?, setter: false},
    })
  end

  enum MessageActivityType
    Join        = 1
    Spectate    = 2
    Listen      = 3
    JoinRequest = 5
  end

  struct MessageApplication
    JSON.mapping({
      id:          {type: UInt64, converter: SnowflakeConverter, setter: false},
      cover_image: {type: String, setter: false},
      description: {type: String, setter: false},
      icon:        {type: String, setter: false},
      name:        {type: String, setter: false},
    })
  end

  struct Reaction
    JSON.mapping({
      count: {type: Int32, setter: false},
      me:    {type: Bool, setter: false},
      emoji: {type: Emoji, setter: false},
    })
  end

  struct Overwrite
    JSON.mapping({
      id:    {type: UInt64, converter: SnowflakeConverter, setter: false},
      type:  {type: String, setter: false}, # either "role" or "member"
      allow: {type: Int32, setter: false},
      deny:  {type: Int32, setter: false},
    })
  end

  struct Embed
    JSON.mapping({
      title:       {type: String, setter: false},
      type:        {type: String, setter: false}, # webhook embeds = "rich"
      description: {type: String?, setter: false},
      url:         {type: String?, setter: false},
      timestamp:   {type: Time, converter: TimestampConverter, setter: false},
      color:       {type: Int32?, setter: false},
      footer:      {type: EmbedFooter?, setter: false},
      image:       {type: EmbedImage?, setter: false},
      thumbnail:   {type: EmbedThumbnail?, setter: false},
      video:       {type: EmbedVideo?, setter: false},
      provider:    {type: EmbedProvider?, setter: false},
      author:      {type: EmbedAuthor?, setter: false},
      fields:      {type: Array(EmbedField)?, setter: false},
    })
  end

  struct EmbedThumbnail
    JSON.mapping({
      url:       {type: String, setter: false},
      proxy_url: {type: String?, setter: false},
      height:    {type: Int32?, setter: false},
      width:     {type: Int32?, setter: false},
    })
  end

  struct EmbedVideo
    JSON.mapping({
      url:    {type: String, setter: false},
      height: {type: Int32?, setter: false},
      width:  {type: Int32?, setter: false},
    })
  end

  struct EmbedImage
    JSON.mapping({
      url:       {type: String, setter: false},
      proxy_url: {type: String?, setter: false},
      height:    {type: Int32?, setter: false},
      width:     {type: Int32, setter: false},
    })
  end

  struct EmbedProvider
    JSON.mapping({
      name: {type: String, setter: false},
      url:  {type: String, setter: false},
    })
  end

  struct EmbedAuthor
    JSON.mapping({
      name:           {type: String, setter: false},
      url:            {type: String?, setter: false},
      icon_url:       {type: String?, setter: false},
      proxy_icon_url: {type: String?, setter: false},
    })
  end

  struct EmbedFooter
    JSON.mapping({
      text:           {type: String, setter: false},
      icon_url:       {type: String?, setter: false},
      proxy_icon_url: {type: String?, setter: false},
    })
  end

  struct EmbedField
    JSON.mapping({
      name:   {type: String, setter: false},
      value:  {type: String, setter: false},
      inline: {type: Bool, setter: false},
    })
  end

  struct Attachment
    JSON.mapping({
      id:        {type: UInt64, converter: SnowflakeConverter, setter: false},
      filename:  {type: String, setter: false},
      size:      {type: Int32, setter: false},
      url:       {type: String, setter: false},
      proxy_url: {type: String?, setter: false},
      height:    {type: Int32?, emit_null: true, setter: false},
      width:     {type: Int32?, emit_null: true, setter: false},
    })
  end
end
