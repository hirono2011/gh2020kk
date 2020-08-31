#!/usr/bin/ruby -Ku
#告訴状-2013-金沢地方検察庁御中_API
require 'uri'

tfile=File.open('./t').read.split("\n")
tdata=tfile.each_slice(3).to_a
tdata.reverse!

pfile=File.open('./p').read
p=pfile.split(/<\/a>/)

pdata=Array.new
p.each do |d|
	pdata << d + "</a>"
end

if tdata.size == pdata.size then
#	puts "#{tdata.size}   ---------------   #{pdata.size}"
	tdata.size.times do |i|
		puts "<div>"
		puts pdata[i]
		uri_reg = URI.regexp(%w[http https])
		tdata[i].each do |t|
			puts t.gsub!(uri_reg) {%Q{<a href="#{$&}" target="_blank">#{$&}</a>}}
		end
		puts "</div>\n"
	end
else
	puts "一致しないです。"
end


