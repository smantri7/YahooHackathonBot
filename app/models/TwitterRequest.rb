require 'twitter'
class TwitterRequest

	def initialize(username)
		@client = Twitter::REST::Client.new do |config|
	  		config.consumer_key        = "ujHZfFxnxD4vmbnXQiHUZ2FWS"
	  		config.consumer_secret     = "lMlxtVXA9fc1zrRILqwdQhxl2wtDpJdpobWdRD4T1D0HbANZuT"
	  		config.access_token        = "2980602431-jOzvKuWwRQ9EPTc9YfqxdxEaCefsLd50QgnXBWI"
	  		config.access_token_secret = "KJXp44JwKD9o1sBrT8qThOj3lxGVT8EVmyHYlZPuFGzOH"
		end
		@username = username
	end

	def getComments()
		all_tweets = []
		tweet = @client.user_timeline(@username, :count => 200)
		all_tweets += tweet
		oldest = all_tweets.last.id - 1
		prev = nil

		while oldest != prev
			new_tweets = @client.user_timeline(@username, :max_id => oldest)
			all_tweets += new_tweets
			prev = oldest
			oldest = all_tweets.last.id - 1

			if all_tweets.length > 2000
				break
			end
		end
		text = ""

		all_tweets.each do |tweet|
			text += preprocess(tweet.text)
		end
		return text
	end

	def preprocess(text)
		ans = ""
		text = text.split()
		text.each do |line|
			if not line.include?("@") and not line.include?("www") and not line.include?(".com") and not line.include?("#") and not line.include?("http")
				ans += line + ' '
			end
		end
		return ans + "\n"
	end
end
