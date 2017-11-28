#!/usr/bin/env ruby

require 'nokogiri'

DIR_DATA='data/'

force = false
separator = ';'
encoding = 'UTF-8'
article_id = false
header = false
wikitag = ''
lang = {}
lang_source = ''
lang_list = []
title_wikitag = {}
rgx = ''

if ARGV.empty?
  STDERR.puts "[ERR] Language was not given"
  exit(false)
else
  while ! ARGV.empty?
    arg = ARGV.shift
    case arg
    when "-s"
      separator = ARGV.shift
      case separator
      when '\t'
        separator = "\t"
      when '\n'
        separator = "\n"
      else
        separator = separator
      end
    when "-f"
      force = true
    when "--id"
      article_id = true
    when "--wikitag"
      wikitag = ARGV.shift
    else
      lang_list.push(arg)
      lang[arg] = {}
    end
  end
  if lang_list.empty? || lang_list.length < 2
    STDERR.puts "[ERR] Language was not given"
    exit(false)
  end
  lang_source = lang_list.shift
  rgx_lang = ''
  lang_list.each do |lang_i|
    if rgx_lang.empty?
      rgx_lang += lang_i
    else
      rgx_lang += '|' + lang_i
    end
  end
  rgx = /[(]([0-9]+),[\'](#{rgx_lang})[\'],[\']((?:[^\'\\\\]|\\\\.)+)[\'][)]/
end

File.open(DIR_DATA + lang_source + '.txt', "r", encoding: encoding) do |infile|
  while (line = infile.gets)
    match = line.strip.encode(encoding, invalid: :replace, undef: :replace, replace: '').match(/^[0-9]+:([0-9]+):(.+)/)
    if match
      id = match[1]
      value = match[2]
      lang[lang_source][id] = value
    end
  end
end

File.open(DIR_DATA + lang_source + '-langlinks.sql', 'r', encoding: encoding) do |infile|
  while (line = infile.gets)
    match = line.strip.encode(encoding, invalid: :replace, undef: :replace, replace: '').scan(rgx)
    if match.length > 0
      match.each do |id,lang_target,value|
        if !value.empty?
          lang[lang_target][id] = value
        end
      end
    end
  end
end

if !wikitag.empty?
  Nokogiri::XML::Reader(File.open(DIR_DATA + lang_source + '-wiki.xml')).each do |node|
    if node.name == 'page' && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
      title = ''
      until node.node_type == Nokogiri::XML::Reader::TYPE_END_ELEMENT && node.name == 'page'
        node.read
        if node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
          case node.name
          when 'title'
            node.read
            title = node.value.strip
          when 'revision'
            until node.node_type == Nokogiri::XML::Reader::TYPE_END_ELEMENT && node.name == 'revision'
              node.read
              if node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT && node.name == 'text'
                node.read
                node.value.lines.map(&:strip).each do |line|
                  if line =~ /#{Regexp.escape(wikitag)}/
                    title_wikitag[title] = 1
                    break
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

lang[lang_source].each do |key,value|
  if !wikitag.empty?
    if !title_wikitag.key?(value)
      next
    end
  end
  line = ''
  not_found = false
  if article_id
    line << key
    line << separator
  end
  line << value
  line << separator
  lang_list.each do |lang_i|
    if lang[lang_i].key?(key)
      line << lang[lang_i][key]
      line << separator
    else
      not_found = true
      line << separator
    end
  end
  line[-1] = ''
  if not_found
    if force
      puts line
    end
  else
    puts line
  end
end
