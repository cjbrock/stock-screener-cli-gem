class StockScreener::Screener

attr_accessor :ticker, :company, :sector, :price, :url

@@all = []

	def self.new_from_screener(r)
		self.new(
			r.css('a.screener-link-primary').text,
			'http://www.finviz.com/screener.ashx?v=111&f=fa_netmargin_pos,sh_avgvol_o2000,ta_candlestick_d&ft=4',
			r.css('td[3]').text,
			r.css('td[4]').text,
			r.css('td[9]').text
			)
	end

	def initialize(ticker=nil, url=nil, company=nil, sector=nil, price=nil)
		@ticker = ticker
		@url = url
		@company = company
		@sector = sector
		@price = price
		@@all << self
	end

	def self.all
		@@all
	end

	def self.find(id)
		self.all[id-1]
	end

	def self.find_by_ticker(ticker)
		self.all.detect do |t|
			t.ticker.downcase.strip == ticker.downcase.strip ||
			t.ticker.split("(").first.strip.downcase == ticker.downcase.strip
		end
	end

end
