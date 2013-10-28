require 'mechanize'
require 'pathname'

browser = Mechanize.new

docs = browser.get('http://nginx.org/en/docs/')


links = docs.links_with(href: %r{^(http|mail)/ngx})
documents = Pathname('Contents/Resources/Documents')

links.each do |link|
  page = link.click
  uri = docs.uri.route_to(page.uri).to_s

  parser = page.parser
  parser.at_css('#banner').parent.parent.remove
  parser.at_css("td[rowspan='2'][align='right'][valign='top']").remove
  page.body = parser.to_html

  documents.join(uri).tap do |doc|
    doc.dirname.mkpath
    page.save_as(doc)
    puts "Saved #{uri}"
  end
end

