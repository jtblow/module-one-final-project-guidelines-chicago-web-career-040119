class Cryptocurrency < ActiveRecord::Base
  has_many :transactions
  has_many :users, through: :transactions


  #USER STORY METHOD - returns cryptocurrency row that matches search name
  def self.search_by_name(name)
    formated_input = name.downcase.split.map{|word| word.capitalize}.join(" ")
    Cryptocurrency.find_by(name: formated_input) || "Please enter a viable search name."
  end

  #USER STORY METHOD - returns cryptocurrency row that matches search ticker
  def self.search_by_ticker(ticker)
    formated_input = ticker.upcase
    Cryptocurrency.find_by(ticker: formated_input) || "Please enter a viable search ticker."
  end

  #USER STORY METHOD - returns overall look at current market
  def self.market_view
    arr = market_view_helper
    table = TTY::Table.new ["Name", "Price ($)", "Market Cap (B)", "24H Change (%)"], arr
    puts table.render(:unicode, alignments: [:center, :center, :center, :center])
  end

  #USER STORY METHOD - returns overall look ordered by biggest gainers
  def self.market_view_by_24hr_gain
    arr = market_view_by_24hr_gain_helper
    table = TTY::Table.new ["Name", "Price ($)", "24H Change (%)"], arr
    puts table.render(:unicode, alignments: [:center, :center, :center])
  end

  #Helper method for .market_view
  def self.market_view_helper
    Cryptocurrency.all.map do |crypto|
      [crypto.name, crypto.usd.round(2), (crypto.market_cap/1000000).round(1), crypto.percent_change_24hr.round(2)]
    end
  end

  #Helper method for .market_view_by_24hr_gain
  def self.market_view_by_24hr_gain_helper
    Cryptocurrency.order(percent_change_24hr: :desc).map do |crypto|
      [crypto.name, crypto.usd.round(2), crypto.percent_change_24hr.round(2)]
    end
  end






  #TTY::Table.new ['header1','header2'], [['a1', 'a2'], ['b1', 'b2']]

end
