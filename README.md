# RSS Fetch
Fetches the latest entries of a website's RSS feed.

## Usage
RSS Fetch uses Nokogiri to work. 

		gem install nokogiri

Go to fetch.rb's directory. Simply input the website of your choice and the number of most recent entries you would like. For example:

		ruby fetch.rb rubyweekly.com 5

If a number is not provided, RSSFetch will fetch the 3 latest entries. 
