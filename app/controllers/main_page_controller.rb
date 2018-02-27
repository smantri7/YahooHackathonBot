require 'TwitterRequest'
require 'JibunBots'

class MainPageController < ApplicationController
  skip_before_action :verify_authenticity_token

  def top
  end

  def index
    @username = params[:username]
    #start up the jibun bot, get results
    if Message.where(:username => @username).first.nil?
      #twitterAnalysis
      tr = TwitterRequest.new(@username)
      tweets = tr.getComments()
      m = Message.new()
      m.username = @username
      m.message = tweets
      m.save!
    end
    @j = JibunBots.new(@username, Message.where(:username => @username).first.message)
    @j.analyze()
    @food =  @j.recPlace()
    @place = @j.recFood()
    @shumi = @j.recInterest()
    aList = [@food, @place, @shumi]
    ran = rand(aList.length)
    picList = ["a.png", "b.png", "c.png", "d.png", "e.png", "g.png"]
    rander = rand(picList.length)
    @src = picList[rander]
    @name = @username[1..@username.length]
    @twitter_comment =  @username + "さんの結果：" + aList[ran] + "面白いね！あなたの夏休みもレベルアップしよう!"
    session[:username] = @username
    session[:bot] = @j
    #puts(j.generateRandomComment(30))
  end

  def chat
    gon.username = params[:username]
  end

  def create
    message = params[:comment]
    bot = session[:bot]
    ans = bot.conversation(message)
    respond_to do |format|
      format.json {render json: {"resp" => ans}}
    end
  end
end
