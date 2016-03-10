require 'slack-ruby-client'
require 'dotenv'
require 'mechanize'
require 'pry'
Dotenv.load
@mechanize = Mechanize.new

Slack.configure do |config|
  config.token = ENV['TOKEN']
end

@client = Slack::Web::Client.new
@realtime = Slack::RealTime::Client.new

def new_message
  page = @mechanize.get('http://trumpem.us/')
  @quote = page.at(".quote")
  @quote.at('cite').remove
  @quote = @quote.text.strip
  @quote.gsub!("Trump", "Drumpf")
  @quote.gsub!("President", "Most Ass-Hattest")
  @quote
end

@realtime.on :message do |data|
  if !!(data.text =~ /[Tt]rump/) || !!(data.text =~ /The Don/)
    @realtime.message channel: data.channel, text: new_message, as_user: true
  end
end

@realtime.start!


# while true
#    new_message
#    sleep 30
# end