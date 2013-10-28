#!/usr/bin/env ruby

require 'nokogiri'
require 'pathname'

documents = Pathname('Contents/Resources/Documents')

puts "CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);"
puts "CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);"

Pathname.glob documents.join('*/*.html') do |file|
  name = file.relative_path_from(documents)
  doc = Nokogiri::HTML(file.read)

  directives = doc.css('a[name] ~ div.directive code strong')
  directives.each do |directive|
    text = directive.text.strip

    puts "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ('#{text}', 'Directive', '#{name}##{text}');"
  end

  vars = doc.css('dl.compact dt[id]')
  vars.each do |var|
    text = var.text.strip
    id = var['id']

    text.split(",\n").each do |text|
      puts "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ('#{text}', 'Variable', '#{name}##{id}');"
    end
  end
end
