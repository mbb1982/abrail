require 'scraperwiki'
require 'nokogiri'
require 'mechanize'
agent = Mechanize.new


def demu
  agent = Mechanize.new
  demu_page = agent.get("http://abrail.co.uk/demuformations.htm")
  first_row = true
  fields = []
  demu_page.search('table tr').each{ |row|
    if first_row
      fields= row.search("td").map{|field| field.inner_text.sub(/Op'r/,"operator").sub(/Set No/,"Number").gsub(/\//," ").gsub!(/\t|\n|\./,"")}
      first_row = false
    else
      values = row.search("td").map{|field| field.inner_text.gsub!(/\t|\n|\./,"")}
      insert_item(fields,values,"stock")
    end
  
  }
  
  
  
end

def insert_item(fields,values,table)
  item ={}
  return if fields[0] == ""
  puts fields[0]
  i=0
  values.each{ |value|
    key = fields[i]
    break if key=="Formation"
    item[key]=value
    i=i.next
  }
  ScraperWiki::save_sqlite(['Number'],item,table)
end


demu
