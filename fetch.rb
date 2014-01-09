require 'nokogiri'
require 'simple-rss'
require 'open-uri'


ARGV.map! { |http| "http://#{http}/"}
ARGV.each do |website|
	doc = Nokogiri::HTML(open(website))
	check = doc.xpath("//link[@type=\"application/rss+xml\"]")
	rss_path = check.map do |link|
		if link['href'] =~ /^http:\/\//
			link['href']
		else
			"#{website}#{link['href']}"
		end
	end
	rss = SimpleRSS.parse open(rss_path[0])
	rss.items.each do |item|
		puts %Q{
			#{item.title}
			#{item.link}
			Published on #{item.pubDate}
		}
	end
end