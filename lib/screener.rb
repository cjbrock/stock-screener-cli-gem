class StockScreener::Screener

attr_accessor :ticker, :company, :sector, :price, :url

	def initialize(ticker=nil, url=nil)
		@ticker = ticker
		@url = url
	end

	def self.all
		@@all ||= scrape_screener
	end

	def self.find(id)
		self.all[id-1]
	end

	def company
		@company ||= doc.search('td[3] a[class="screener-link"]').text.strip
		#screener-content > table > tbody > tr:nth-child(4) > td > table > tbody > tr:nth-child(2) > td:nth-child(3) > a
	end

	def sector
		@sector ||= doc.search('td[4] a[class="screener-link"]').text.strip
	end

	def price
		@sector ||= doc.search('td[9] a[class="screener-link"] span').text.strip
	end

	def self.find_by_ticker(ticker)
		self.all.detect do |t|
			t.ticker.downcase.strip == ticker.downcase.strip ||
			t.ticker.split("(").first.strip.downcase == ticker.downcase.strip
		end
	end

	def self.scrape_screener
		doc = Nokogiri::HTML(open("http://www.finviz.com/screener.ashx?v=111&f=fa_netmargin_pos,sh_avgvol_o2000,ta_candlestick_d&ft=4"))
		tickers = doc.search('a[class="screener-link-primary"]')
		tickers.collect{|e| new(e.text.strip, "http://finviz.com#{e.attr("href").split("?").first.strip}")}
	end

	def doc
		@doc ||= Nokogiri::HTML(open(self.url))
	end

	def scrape_page	
		@doc = Nokogiri::HTML(open("http://www.finviz.com/screener.ashx?v=111&f=fa_netmargin_pos,sh_avgvol_o2000,ta_candlestick_d&ft=4"))
	end

	def scrape_stocks
		self.scrape_page.css("tbody[3] tr")
	end

	def make_stocks
		scrape_stocks.each do |r|
			self.new_from_index_page(r)
		end
	end

end