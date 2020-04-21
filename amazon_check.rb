require 'nokogiri'
require 'faraday'
require 'twilio-ruby'
require_relative 'mylinks'
require_relative 'config'

user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"

account_sid = $ACCOUNT_SID
auth_token = $AUTH_TOKEN

from = $FROM
to = $TO

client = Twilio::REST::Client.new(account_sid, auth_token)

loop do
  found = false
  $links.each do |link|
    puts link
    begin
      f = Faraday.new(link, headers: {'User-Agent' => user_agent}).get
      html = f.body

      parsed_html = Nokogiri::HTML.parse(html)

      availability = ""
      parsed_html.xpath("//div[@id='availability']/span").each do |tag|
        availability << tag.content.strip.downcase
      end
    rescue
      next
    end

    if availability.include? "in stock"
      found = true

      message = "TP! #{link}"

      puts message

      client.messages.create(
        from: from,
        to: to,
        body: message
      )

      break

    end
  end
  break if found == true

  sleep(20)
end
