require "tiny_segmenter"
require 'yahoo-japanese-analysis'
class JibunBots

	def initialize(username, zenbu)
		@username = username
		@zenbu = zenbu
		#dictionary of words
		@wordList = {}
		@words = tokenize()
		@size = @words.length
		triples()
		#foods
		@foodDict = setFood()
		@foodList = []
		#places
		@placeDict = setPlace()
		@placeList = []
		#interests
		@shumiDict = setInterests()
		@shumiList = []


		#Interesting info
		@wordbank = {}
	end

	def tokenize()
		byte_string = @zenbu
		segmenter = TinySegmenter.new
		words = segmenter.segment(byte_string)
		return words		
	end

	def tokenize_input(inp)
		data = inp.strip.to_s
		segmenter = TinySegmenter.new
		words = segmenter.segment(data)
		return words
	end

	def triples()
		if @words.length < 3
			return ["おはよう", "おはよう", "おはよう"]
		end
		i = 0
		while i < @words.length - 2
			aList = [@words[i], @words[i + 1], @words[i + 2]]
			database(aList)
			i += 1
		end
	end

	def database(aList)
		one = aList[0]
		two = aList[1]
		three = aList[2]
		key = [one, two]
		if @wordList.include?(key)
			@wordList[key] << three
		else
			@wordList[key] = [three]
		end
	end

	def generateRandomComment(size)
		seeder = rand(@size - 3)
		seedWord, nextWord = @words[seeder], @words[seeder + 1]
		wordOne, wordTwo = seedWord, nextWord
		genList = []
		x = 0
		while x < size
			genList << wordOne
			wordOne, wordTwo = wordTwo, @wordList[[wordOne, wordTwo]][0]
			x += 1
		end
		genList << wordTwo
		ans = ""
		genList.each do |w|
			ans += w
		end
		best = ans + randomfaces()
		return best
	end

	def randomfaces()
		faces = ["凸(｀0´)凸", "ω(=＾・＾=)ω", ">゜))))彡", "(*´･з･)", "(　＾Θ＾)", "ヘ（。□°）ヘ", "(*´_ゝ｀)", "（￣へ￣）", "(*´ω｀)o", "(^～^)"]
		ran = rand(faces.length)
		return faces[ran]
	end

	def setFood()
		pName = Rails.root.to_s + "/app/assets/data/food.csv"
		reader = File.open(pName, "r:UTF-8")
		aDict = {}
		reader.each_line do |line|
			line = line.split(",")
			line[0] = line[0].remove("\n")
			line[1] = line[1].remove("\n")
			if !aDict.keys.include?(line[1])
				aDict[line[1]] = [line[0]]
			else
				aDict[line[1]] += [line[0]]
			end
		end
		return aDict
	end

	def recFood()
		if @foodList.length == 0
			r = rand(@foodDict.keys.length)
			key = @foodDict.keys[r]
			q = rand(@foodDict[key].length)
			return "実はあなたの好きな食べ物がよくわからん。でも、" + @foodDict[key][q] + "を食べてみてください！"
		end
		ran = rand(@foodList.length)
		like = @foodList[ran]
		if @foodDict.keys.include?(like)
			a = "あなたは" + like + "が好きだよね！"
			r = rand(@foodDict[like].length)
			b = "じゃあ、" + @foodDict[like][r] + "を食べてください！"
			return a + b
		else
			key = getKey(like, @foodDict)
			r = rand(@foodDict[key].length)
			return "あなたは" + like + "が好きだから、" + @foodDict[key][r] + "を食べてみてくださいね！"
		end
	end

	def sentimentAnalysis()
		puts("TODO")
	end

	def foodAnalysis(sentence)
		ans = []
		sentence = tokenize_input(sentence)
		sentence.each do |word|
			@foodDict.keys.each do |key|
				@foodDict[key].each do |value|
					if word == key or word == value
						if @wordbank.keys.include?(key)
							@wordbank[key] += 1
						else
							@wordbank[key] = 1
						end
						ans << word
					end
				end
			end
		end

		ans.each do |food|
			if !@foodList.include?(food)
				@foodList << food
			end
		end
	end

	def setInterests()
		pName = Rails.root.to_s + "/app/assets/data/shumi.csv"
		reader = File.open(pName, "r:UTF-8")
		aDict = {}
		reader.each_line do |line|
			line = line.split(",")
			line[0] = line[0].remove("\n")
			line[1] = line[1].remove("\n")
			if !aDict.keys.include?(line[1])
				aDict[line[1]] = [line[0]]
			else
				aDict[line[1]] += [line[0]]
			end
		end
		return aDict
	end

	def interestsAnalysis(sentence)
		ans = []
		sentence = tokenize_input(sentence)
		sentence.each do |word|
			@shumiDict.keys.each do |key|
				@shumiDict[key].each do |value|
					if word == key or word == value
						if @wordbank.keys.include?(key)
							@wordbank[key] += 1
						else
							@wordbank[key] = 1
						end
						ans << word
					end
				end
			end
		end

		ans.each do |shumi|
			if !@shumiList.include?(shumi)
				@shumiList << shumi
			end
		end		
	end

	def recInterest()
		if @shumiList.length == 0
			r = rand(@shumiDict.keys.length)
			key = @shumiDict.keys[r]
			q = rand(@shumiDict[key].length)
			return "実はあなたの好きな趣味がよくわからん。でも、" + @shumiDict[key][q] + "をやってみてください！"
		end
		ran = rand(@shumiList.length)
		like = @shumiList[ran]
		if @shumiDict.keys.include?(like)
			a = "あなたは" + like + "が好きだよね！"
			r = rand(@shumiDict[like].length)
			b = "じゃあ、" + @shumiDict[like][r] + "をやってください！"
			return a + b
		else
			key = getKey(like, @shumiDict)
			r = rand(@shumiDict[key].length)
			return "あなたは" + like + "が好きだから、" + @shumiDict[key][r] + "をやってみてくださいね！"
		end	
	end

	def setPlace()
		pName = Rails.root.to_s + "/app/assets/data/places.csv"
		reader = File.open(pName, "r:UTF-8")
		aDict = {}
		reader.each_line do |line|
			line = line.split(",")
			line[0] = line[0].remove("\n")
			line[1] = line[1].remove("\n")
			if !aDict.keys.include?(line[1])
				aDict[line[1]] = [line[0]]
			else
				aDict[line[1]] += [line[0]]
			end
		end
		return aDict		
	end

	def placeAnalysis(sentence)
		ans = []
		sentence = tokenize_input(sentence)
		sentence.each do |word|
			@placeDict.keys.each do |key|
				@placeDict[key].each do |value|
					if word == key or word == value
						if @wordbank.keys.include?(key)
							@wordbank[key] += 1
						else
							@wordbank[key] = 1
						end
						ans << word
					end
				end
			end
		end

		ans.each do |place|
			if !@placeList.include?(place)
				@placeList << place
			end
		end			
	end

	def recPlace()
		if @placeList.length == 0
			r = rand(@placeDict.keys.length)
			key = @placeDict.keys[r]
			q = rand(@placeDict[key].length)
			return "実はあなたの好きな場所がよくわからん。でも、" + @placeDict[key][q] + "に行ってみてください！"
		end
		ran = rand(@placeList.length)
		like = @placeList[ran]
		if @placeDict.keys.include?(like)
			a = "あなたは" + like + "が好きだよね！"
			r = rand(@placeDict[like].length)
			b = "じゃあ、" + @placeDict[like][r] + "に行ってください！"
			return a + b
		else
			key = getKey(like, @placeDict)
			r = rand(@placeDict[key].length)
			return "あなたは" + like + "が好きだから、" + @placeDict[key][r] + "に行ってみてくださいね！"
		end			
	end

	def conversation(inp)
		#check for key commands: #food #place #shumi
		if inp == "#food"
			return recFood()
		elsif inp == "#place" 
			return recPlace()
		elsif inp == "#shumi" 
			return recInterest()
		end
	end

	def getKey(val, dict)
		dict.keys.each do |key|
			if dict[key].include?(val)
				return key
			end
		end 
	end

	def analyze()
		lines = @zenbu.split("\n")
		lines.each do |sentence|
			foodAnalysis(sentence)
			interestsAnalysis(sentence)
			placeAnalysis(sentence)
		end
	end

	def getCommonWords()
		best = @wordbank.sort_by { |_, v| -v }.first(5).map(&:first)
		puts(best)
		ans = "よく使ってる言葉： "
		bns = ""
		best.each do |key|
			bns += key + ": " + @wordbank[key].to_s + "回 "
		end
		return ans + bns
	end

	def fileToList(file)
		reader = File.open(file, "r:UTF-8", &:read)
		names = reader.split
		return names
	end
end
