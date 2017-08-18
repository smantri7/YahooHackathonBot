require 'TwitterRequest'
require 'JibunBots'

class MainPageController < ApplicationController
  skip_before_action :verify_authenticity_token
  def top
  end

  def index
  	@username = params[:username]
  	if Message.where(:username => @username).first.nil?
  		#twitterAnalysis
  		tr = TwitterRequest.new(@username)
  		tweets = tr.getComments()
  		m = Message.new()
  		m.username = @username
  		m.message = tweets
  		m.save!
  	end
  	#start up the jibun bot, get results
    @j = JibunBots.new(@username, Message.where(:username => @username).first.message)
    @j.analyze()
    #puts(j.generateRandomComment(30))
  end

  def chat
    @username = params[:username]
    gon.username = @username
  end

  def create
    message = params[:comment]
    j = JibunBots.new(params[:username], Message.where(:username => params[:username]).first.message)
    j.analyze()
    ans = j.conversation(message)
    respond_to do |format|
      format.json {render json: {"resp" => ans}}
    end
  end
end
