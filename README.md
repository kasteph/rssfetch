# RSS Fetch
Welcome. RSS Fetch fetches the latest entries of a website's RSS feed.

## Usage
RSS Fetch uses Nokogiri and Simple-RSS to work. 

		gem install nokogiri
		gem install simple-rss

Go to fetch.rb's location. Simply input the website of your choice and RSS Fetch will search for the website's RSS feed. For example:

		ruby fetch.rb rubyweekly.com 8gramgorilla.com
	