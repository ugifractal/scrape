#!/usr/bin/env ruby

# Wow, looks like there are still jobs for Cobol

require 'csv'
require 'mechanize'
require 'optparse'
require 'paint'

# implement commandline options
options = {:keyword => nil}

parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{Paint['seek.rb [options]', :red, :white]}"

  opts.on('-k', '--keyword keyword', 'Keywords to search') do |keyword|
    options[:keyword] = keyword
  end

  opts.on('-h', '--help', 'Displays help') do
    puts opts
    exit
  end
end

parser.parse!

if options[:keyword].nil?
  print 'Enter keywords: '
  options[:keyword] = STDIN.gets.chomp
end

agent = Mechanize.new
agent.user_agent_alias = 'Windows Chrome'
site = 'https://www.seek.com.au'
page = agent.get site
form = page.form_with :name => 'SearchBar'
form.field_with(:name => 'keywords').value = options[:keyword]
page = agent.submit form

def extract(link, site)
  [link.text.strip, site + link.attributes['href'].value]
end
results = []
results << %w[Title URL Advertiser Location]

loop do
  # for each page # html = page.body
  jobs = page.search('article')
  jobs.each do |job|
    title, url = extract(job.css('a')[0], site)
    a_name, a_url = extract(job.css('a')[1], site)
    location, l_url = extract(job.css('a')[2], site)

    results << [title, url, a_name, location]
  end

  if link = page.link_with(:text => 'Next') # As long as there is still a nextpage link...
    page = link.click
  else # If no link left, then break out of loop
    break
  end
end

if results.size > 1
  CSV.open("jobs/#{options[:keyword].tr(' ', '-')}.csv", 'w+') do |csv_file|
    results.each do |row|
      csv_file << row
    end
  end
end