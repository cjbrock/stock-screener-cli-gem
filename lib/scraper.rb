class StockScreener::Scraper
	def scrape_page
		Nokogiri::HTML(open("http://www.finviz.com/screener.ashx?v=111&f=fa_netmargin_pos,sh_avgvol_o2000,ta_candlestick_d&ft=4"))
	end

	def scrape_stocks
		sleep 10
		self.scrape_page.css("#screener-content > table > tr:nth-child(4) > td > table > tr[valign='top']")
	end

	def make_stocks
		scrape_stocks.each do |r|
			StockScreener::Screener.new_from_screener(r)
		end
	end
end

#screener-content > table > tbody > tr:nth-child(4) > td > table > tbody > tr:nth-child(2)
