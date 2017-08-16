require 'TwitterRequest'
require 'JibunBots'

class MainPageController < ApplicationController
  def top
  end

  def index
  	username = params[:username]
  	if Message.where(:username => username).first.nil?
  		#twitterAnalysis
  		tr = TwitterRequest.new(username)
  		tweets = tr.getComments()
  		m = Message.new()
  		m.username = username
  		m.message = tweets
  		m.save!
  	end
  	#start up the jibun bot, get results
    @j = JibunBots.new(username, Message.where(:username => username).first.message)
    @j.analyze()
    #puts(j.generateRandomComment(30))
  end
end
