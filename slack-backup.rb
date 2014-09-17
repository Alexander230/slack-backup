#!/usr/bin/ruby

require "slack"

Slack.configure do |config|
  config.token = "MY-API-TOKEN"
end

users = Slack.users_list["members"]
channels = Slack.channels_list["channels"]

channels.each do |channel|
  messages = Slack.channels_history({"channel" => channel["id"], "count" => "1000"})["messages"]
  f = File.open("#{channel['name']}.txt","w")
  messages.reverse_each do |msg|
    if (msg.has_key?("text") && msg.has_key?("user"))
      username = msg["user"]
      users.each do |user|
        if user["id"] == msg["user"]
          username = user["name"]
        end
      end
      f.write("#{username}: #{msg["text"]}\r\n")
    end
  end
  f.close
end
