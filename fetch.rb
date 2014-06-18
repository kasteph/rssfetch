require 'nokogiri' 
# require 'simple-rss'
require 'open-uri'


class RSSFetch

	attr_accessor :url
	attr_reader :doc
	
	def initialize(url)
		if url =~ %r{^http(s)?://}
			@url = url			
			@doc = Nokogiri::HTML(open(url))
		else
			@doc = Nokogiri::HTML(open("http://#{url}"))
		end
	end

	def has_feed?
		!rss_links.empty?
	end

	def rss_links
		doc.xpath("//link[@type=\"application/rss+xml\"]").map do |link|
			if link['href'] =~ /^http:\/\//
				link['href']
			else
				"#{@url}#{link['href']}"
			end
		end
	end

	def items
		# SimpleRSS.parse(open(rss_links.first)).items
    puts "#{rss_links.first}" # Get the 0th item from array
    @xml_doc = Nokogiri::XML(open(rss_links.first))
    
    # puts "parsed_xml #{parsed_xml}"
    title = @xml_doc.xpath("//title")
    pubDate = @xml_doc.xpath("//pubDate")
    link = @xml_doc.xpath("//link")

    titles = strip_xml_tag title
    pubDates = strip_xml_tag pubDate
    links = strip_xml_tag link

    puts titles
    puts pubDates
    puts links
	end

  def strip_xml_tag(tag)
    tags = tag.map do |t|
      t.inner_text()
    end
  end

end

class RSSItem
  # accessors perhaps?

  # title
  def title 
  end

  # link
  def link
  end
  
  # date
  def date
  end

end

ARGV.each do |arg|
	# begin
		checker = RSSFetch.new(arg)
		
		if checker.has_feed?
			puts "Items from #{arg}:"
      checker.items
			# checker.items.each do |item|
   #     puts %Q{
   #      #{item.title}
   #      #{item.link}
   #      Published on #{item.pubDate}
   #     }
			# end
			puts
			puts
		else
			puts "#{arg} has no RSS feed."
  	end

	# rescue
	# 	puts "URL does not begin with HTTP."
	# end
end
