#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'

url = 'https://en.wikipedia.org/wiki/List_of_Wikipedias'
xpath1 = '//table[tr/th[1]/text() = \'Language\'][tr/th[3]/text() = \'Wiki\']/tr/td[position() = 1]/a/text()'
xpath2 = '//table[tr/th[1]/text() = \'Language\'][tr/th[3]/text() = \'Wiki\']/tr/td[position() = 3]/a/text()'

html = open(url).read
page = Nokogiri::HTML(html)

lang_name = page.xpath(xpath1)
lang_short = page.xpath(xpath2)

if lang_name.length == lang_short.length
  lang = {}
  counter = 0
  counter_max = lang_name.length
  while true
    if counter < counter_max
      lang[lang_short[counter].to_s.strip] = lang_name[counter].to_s.strip
      counter += 1
    else
      break
    end
  end
  lang.sort.map do |key,value|
    print key, ' = ', value, "\n"
  end
else
  STDERR.puts '[ERR] Something goes wrong!'
  STDERR.puts '[ERR] Found %d language name' %(lang_name.length)
  STDERR.puts '[ERR] Found %d language short name' %(lang_short.length)
  exit(false)
end
