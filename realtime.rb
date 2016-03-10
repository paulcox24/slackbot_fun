require 'slack-ruby-client'
require 'dotenv'
require 'mechanize'
Dotenv.load
@mechanize = Mechanize.new

Slack.configure do |config|
  config.token = ENV['TOKEN']
end

@client = Slack::Web::Client.new
@realtime = Slack::RealTime::Client.new

def new_message
  page = @mechanize.get('http://trumpem.us/')
  @quote = page.at(".quote").text.strip
  @client.chat_postMessage(channel: '#general', text: @quote, as_user: true)
end

while true
   new_message
   sleep 30
end