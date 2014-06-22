require 'rubygems'
require 'nokogiri'         
require 'open-uri'
require 'csv'



$file = "quotes.csv"

#webscrap brainyquote.com

def scrap_bq(topic)
	puts 'SCRAPING BRAINYQUOTE.COM'	

	for page in 1..40
		puts "reading page #{page} - #{topic}"

		url = "http://www.brainyquote.com/quotes/topics/topic_"+topic+".html"
		url = "http://www.brainyquote.com/quotes/topics/topic_"+topic+page.to_s+".html" if !page == 1
		page = Nokogiri::HTML(open(url))   
		quotes = page.css("div#quotesList")

		quotes.css(".boxyPaddingBig").each do |q|
			quote = q.css(".bqQuoteLink a")[0].text
			author = q.css(".bq-aut a")[0].text

			CSV.open($file, "ab") do |csv|
  				csv << [quote, author, topic, "brainyquote.com", "en"]
			end

		end
		
	end

end


scrap_bq("success")
scrap_bq("failure")
scrap_bq("happiness")
scrap_bq("money")
scrap_bq("love")
scrap_bq("motivational")
scrap_bq("leadership")
scrap_bq("freedom")
scrap_bq("business")
scrap_bq("dreams")
scrap_bq("fitness")
scrap_bq("finance")



#webscrap frasescelebres.com

def scrap_fc(topic, limit_page)
	puts 'SCRAPING FRASESCELEBRES.COM'

	for page in 1..limit_page
		puts "reading page #{page} - #{topic}"

		url = "http://www.frasescelebres.com/frases-de-"+topic+"/p"+page.to_s
		doc = Nokogiri::HTML(open(url))   
		quotes = doc.css("div#cont_left")

		quotes.css(".box").each_with_index do |q, i|
			#the first block is not a quote
			if i > 0
				quote = q.css(".texto_frase")[0].text
				author = q.css(".links_frase a")[1].text
				quote = quote.split('"')
				quote = quote[0].strip

				CSV.open($file, "ab") do |csv|
	  				csv << [quote, author, topic, "frasescelebres.com", "es"]
				end
			end

		end
		
	end

end

scrap_fc("amor", 9)
scrap_fc("exito", 1)
scrap_fc("dinero", 2)

#webscrap proverbia.com

def scrap_pb(topic_value, limit_page)
	puts 'SCRAPING PROVERBIA.COM'

	for page in 1..limit_page

		url = "http://www.proverbia.net/citastema.asp?tematica="+topic_value.to_s+"&page="+page.to_s
		doc = Nokogiri::HTML(open(url))   
		topic = doc.css("div#content h1")[0].text
		puts "reading page #{page} - #{topic}"
		quotes = doc.css("div#ql")
		
		quotes.css(".q").each do |q|
			quote = q.css(".t")[0].text
			author = q.css(".a a")[0].text

			CSV.open($file, "ab") do |csv|
  				csv << [quote, author, topic.downcase, "proverbia.com", "es"]
			end
		end
		
	end

end

scrap_pb(11, 15) #money
scrap_pb(1, 54) #love
scrap_pb(4, 16) #happiness


#webscrap frasecelebre.net

def scrap_fn(topic, limit_page)

	puts 'SCRAPING FRASECELEBRE.NET'

	for page in 0..limit_page
		puts "reading page #{page} - #{topic}"

		url = "http://www.frasecelebre.net/Frases_De_"+topic+".html" 
		url = "http://www.frasecelebre.net/Frases_De_"+topic+"_"+page.to_s+".html" if page != 0

		doc = Nokogiri::HTML(open(url))   
		quotes = doc.css("div.bq")
		
		quotes.css(".q").each do |q|
			quote = q.css(".Frase blockquote")[0].text
			author = q.css(".social_links a")[0].text
			topic = "sueño" if topic == "sueno"

			CSV.open($file, "ab") do |csv|
  				csv << [quote, author, topic, "frasecelebre.net", "es"]
			end
			topic = "sueno" if topic == "sueño"
		end
		
	end

end

scrap_fn("dinero", 25)
scrap_fn("amor", 45)
scrap_fn("motivacion", 5)
scrap_fn("error", 16)
scrap_fn("economia", 9)
scrap_fn("inversiones", 4)
scrap_fn("superacion", 6)
scrap_fn("riesgos", 5)
scrap_fn("exito", 15)
scrap_fn("sueno", 16)




