require 'sinatra'
require 'csv'
require 'pry'

########## METHODS ############
def get_data(roster)
  teams = []
  CSV.foreach(roster, headers: true, header_converters: :symbol, converters: :integer) do |row|
    teams << row.to_hash
  end
  teams
end

def sorthash(hash)
  hash.sort_by {|key, value| value}
end
################################

get '/' do
  @teams = get_data("teams.csv")
  erb :index
end


get '/leaderboard' do
  @teams = get_data("teams.csv")
  winning_team = Hash.new(0)
  losing_team = Hash.new(0)
  winning_array = []
  losing_array = []

####### Makes a hash of winning teams ###########
  @teams.each do |team|
    if team[:away_score] < team[:home_score]
      winning_array << team[:home_team]
    elsif team[:away_score] > team[:home_score]
      winning_array << team[:away_team]
    else
      nil
    end
  end
  winning_array.each do |teamwins|
    winning_team[teamwins] += 1
  end

######### Makes a hash of losing teams ###########
  @teams.each do |team|
    if team[:away_score] > team[:home_score]
      losing_array << team[:home_team]
    elsif team[:away_score] < team[:home_score]
      losing_array << team[:away_team]
    else
      nil
    end
  end
  losing_array.each do |teamlose|
    losing_team[teamlose] += 1
  end
  @win = sorthash(winning_team).reverse
  @lose = sorthash(losing_team)
  erb :leaderboard
end


=begin
get '/team/:team' do
  @teams = get_data("teams.csv")
  params[:team]
  @homet = Hash.new
  @awayt = Hash.new
  @teams.each do |t|
    if params[:team] == t[:home_team]
      @homet = t
    end
    binding.pry
  end
  erb :team
end
=end





















