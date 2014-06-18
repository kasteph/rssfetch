require 'nokogiri'
require 'open-uri'


class RSSFetch

	attr_accessor :url, :rss_length
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

  # Look for RSS links in page
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
    # Get the 0th item from array and open with Nokogiri
    xml_link = rss_links.first
    @xml_doc = Nokogiri::XML open(xml_link)
  

    # Get all the titles, dates, and links from the RSS
    # and strip their XML tag
    titles    = strip_xml_tag @xml_doc.xpath("//title")
    pub_dates = strip_xml_tag @xml_doc.xpath("//pubDate")
    links     = strip_xml_tag @xml_doc.xpath("//link")
    
    make_rss_item titles, pub_dates, links

  end

  def strip_xml_tag(tag)
    tags = tag.map do |t|
      t.inner_text()
    end
  end

  def make_rss_item(titles, pub_dates, links)
    titles.each_with_index do |title, index|
      puts "#{title}\n#{pub_dates[index]}\n#{links[index]}\n\n"
      
      # TODO
      # RSSItem.new(title, pub_dates[index], links[index])
    end
  end

end

class RSSItem

  def initialize(title, pub_date, link)
    @title    = title
    @pub_date = pub_date
    @link     = link
  end


  def title
    @title
  end


  def link
    @link
  end
  

  def date
    @pub_date
  end

end

ARGV.each do |arg|
	begin
		checker = RSSFetch.new(arg)
		
		if checker.has_feed?
			puts "\n\nItems from #{arg}: \n\n\n"
      checker.items

		else
			puts "#{arg} has no RSS feed."
  	end

	rescue
		puts "URL does not begin with HTTP."
	end
end
