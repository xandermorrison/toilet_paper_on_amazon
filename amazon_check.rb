require 'nokogiri'
require 'faraday'
require_relative 'mylinks'

user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"

loop do
  #sleep(20)
  found = false
  $links.each do |link|

    f = Faraday.new(link, headers: {'User-Agent' => user_agent}).get
    html = f.body

    parsed_html = Nokogiri::HTML.parse(html)

    availability = ""
    parsed_html.xpath("//div[@id='availability']/span").each do |tag|
      availability << tag.content.strip.downcase
    end

    puts availability
    if availability.include? "in stock"
      found = true
      puts "HERE"
      break
      # send text message
    end
  end
  break if found == true
end
