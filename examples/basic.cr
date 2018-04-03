require "../src/cord"

rest = Cord::Discord::REST.new "Bot N"
puts rest.request(
  route_key: :users_me,
  major_param: nil,
  method: "GET",
  path: "/users/@me"
).body
