#!/usr/bin/env ruby

# Wow, looks like there are still jobs for Cobol

require 'csv'
require 'mechanize'
require 'optparse'
require 'paint'

VERSION = '1.0.0'.freeze

def wtype(worktype)
  case worktype
  when 'full'
    242
  when 'part'
    243
  when 'contract'
    244
  when 'casual'
    245
  when '242'
    242
  when '243'
    243
  when '244'
    244
  when '245'
    245
  else
    '242%2C243%2C244%2C245'
  end
end

def enwtype(i)
  case i
  when 242
    'full'
  when 243
    'part'
  when 244
    'contract'
  when 245
    'casual'
  else
    'all'
  end
end

# implement commandline options
options = {:keyword => nil, :location => nil, :daterange => nil, :worktype => nil}

parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{Paint['seek.rb [options]', :red, :white]}"

  opts.on('-k', '--keyword keyword', 'Keywords to search
                                        separators include:
                                        and, or, not') do |keyword|
    options[:keyword] = keyword
  end

  opts.on('-l', '--location location', 'Suburb, city or region') do |location|
    options[:location] = location
  end

  opts.on('-d', '--daterange daterange', 'Listed time in days
                                        999 (default) or
                                        1, 3, 7, 14, 31 or
                                        any positive number') do |daterange|
    options[:daterange] = daterange
  end

  opts.on('-w', '--worktype worktype', 'Work type
                                        all (default)
                                        full or 242 (full time)
                                        part or 243 (part time)
                                        contract or 244 (contract/temp)
                                        casual or 245 (casual/vacation)') do |worktype|
    worktype = wtype(worktype)
    options[:worktype] = worktype
  end

  opts.on('-h', '--help', 'Displays help') do
    puts opts
    exit
  end

  opts.on_tail('--version', 'Show version') do
    puts VERSION
    exit
  end
end

parser.parse!

if options[:keyword].nil?
  print 'Enter keywords: '
  options[:keyword] = STDIN.gets.chomp
end
if options[:location].nil?
  print 'Enter suburb, city or region: '
  options[:location] = STDIN.gets.chomp
end
if options[:daterange].nil?
  print 'Listed time in days: '
  options[:daterange] = STDIN.gets.chomp
end
if options[:worktype].nil?
  print 'Work type: '
  options[:worktype] = wtype(STDIN.gets.chomp)
end

agent = Mechanize.new
agent.user_agent_alias = 'Windows Chrome'
site = 'https://www.seek.com.au'
page = agent.get(site + '/jobs', [['keywords', options[:keyword]],
                                  ['where', options[:location]],
                                  ['daterange', options[:daterange]],
                                  ['worktype', options[:worktype]]])
results = []
results << ['Title', 'URL', 'Advertiser', 'Location', 'Area', 'Listing Date', 'Salary',
            'Classification', 'Sub Classification', 'Work Type', 'Short Description']

loop do
  # for each page # html = page.body
  jobs = page.search('article')
  jobs.each do |job|
    title = job.xpath('@aria-label')
    url = site + job.xpath('descendant::a[@data-automation="jobTitle"]/@href').to_s
    advertiser = job.xpath('descendant::a[@data-automation="jobCompany"]/text()')
    location = job.xpath('descendant::a[@data-automation="jobLocation"]/text()')
    area = job.xpath('descendant::a[@data-automation="jobArea"]/text()')
    listing_date = job.xpath('descendant::span[@data-automation="jobListingDate"]/text()')
    salary = job.xpath('descendant::span[@data-automation="jobSalary"]/span/text()')
    classification = job.xpath('descendant::a[@data-automation="jobClassification"]/text()')
    sub_classification = job.xpath('descendant::a[@data-automation="jobSubClassification"]/text()')
    short_description = job.xpath('descendant::span[@data-automation="jobShortDescription"]//text()')

    # get details from job ad page
    ad = agent.get(url)
    # at selects the first using CSS selectors
    work_type = ad.at('dd[data-automation="job-detail-work-type"]').text
    listing_date = ad.at('dd[data-automation="job-detail-date"]').text if listing_date.empty?

    results << [title, url, advertiser, location, area, listing_date, salary,
                classification, sub_classification, work_type, short_description]
  end

  if (link = page.link_with(:text => 'Next')) # As long as there is still a next page link
    page = link.click
  else # If no link left, then break out of loop
    break
  end
end

if results.size > 1
  keyword = options[:keyword].tr(' ', '-')
  location = options[:location].tr(' ', '-') unless options[:location].empty?
  daterange = 'daterange-' + options[:daterange] unless options[:daterange].empty?
  options[:worktype] = enwtype(options[:worktype])
  worktype = 'worktype-' + options[:worktype] unless options[:worktype].empty?
  filename = [keyword, location, daterange, worktype].compact.join('-').downcase
  filename = filename[1..-1] if filename[0] == '-'
  CSV.open("jobs/#{filename}.csv", 'w+') do |csv_file|
    results.each do |row|
      csv_file << row
    end
  end
  puts "#{results.size - 1} jobs found"
  `open "jobs/#{filename}.csv"`
end
