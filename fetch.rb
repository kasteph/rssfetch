require 'nokogiri'
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


  # TODO
  # get_items method (separate from show_items)


	def show_items(n_most_recent)
    # Get the 0th item from array and open with Nokogiri
    xml_link = rss_links.first
    @xml_doc = Nokogiri::XML open(xml_link)
  

    # Get all the titles, dates, and links from the RSS
    # and strip their XML tag
    titles    = strip_xml_tag @xml_doc.xpath("//title")
    pub_dates = strip_xml_tag @xml_doc.xpath("//pubDate")
    links     = strip_xml_tag @xml_doc.xpath("//link")
    
    item_list = make_rss_item titles, pub_dates, links, n_most_recent

    puts item_list

  end

  def strip_xml_tag(tag)
    tags = tag.map do |t|
      t.inner_text()
    end
  end

  def make_rss_item(titles, pub_dates, links, n_most_recent)
    titles[0, n_most_recent].each_with_index.map do |title, index|
      RSSItem.new(title, pub_dates[index], links[index])
    end
  end

end

class RSSItem

  def initialize(title, pub_date, link)
    @title    = title
    @pub_date = pub_date
    @link     = link
  end

  def to_s
    "#{@title}\n#{@pub_date}\n#{@link}\n\n"
  end

end


arg = ARGV[0]
num = ARGV[1]
n_most_recent = num.nil? ? 3 : num.to_i


checker = RSSFetch.new(arg)

if checker.has_feed?
	puts "\n\nItems from #{arg}: \n\n\n"
  checker.show_items(n_most_recent)

else
	puts "#{arg} has no RSS feed."
end
