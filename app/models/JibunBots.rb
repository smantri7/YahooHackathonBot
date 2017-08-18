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
		@greetings = ["おはよう", "おはようございます", "こんにちは", "こんばんは", "ヘロー", "おは"]
		@bye = ["失礼します", "じゃね", "またね", "じゃまた", "バイバイ"]

		YahooJA.configure do |config|
  			config.app_key = 'dj00aiZpPXFDREplS1NyR09rSyZzPWNvbnN1bWVyc2VjcmV0Jng9NzM-'
		end

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

	def generateRandomCommentWord(size, word)
		wordPos = 0
		while wordPos < @words.length
			if @words[wordPos] == word
				break
			end
			wordPos += 1	
		end
		seedWord, nextWord = word, @words[wordPos + 1]
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
			return "好きな食べ物がよくわからんけど、" + @foodDict[key][q] + "を食べてみて～！"
		end
		ran = rand(@foodList.length)
		like = @foodList[ran]
		if @foodDict.keys.include?(like)
			a = like + "が好きだよね！"
			r = rand(@foodDict[like].length)
			b = "じゃあ、" + @foodDict[like][r] + "を食べてみて～！"
			return a + b
		else
			key = getKey(like, @foodDict)
			r = rand(@foodDict[key].length)
			return like + "が好きだから、" + @foodDict[key][r] + "を食べてみて～！"
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
			return "好きな趣味がよくわからんけど、" + @shumiDict[key][q] + "をやってみて～！"
		end
		ran = rand(@shumiList.length)
		like = @shumiList[ran]
		if @shumiDict.keys.include?(like)
			a = like + "が好きだよね！"
			r = rand(@shumiDict[like].length)
			b = "じゃあ、" + @shumiDict[like][r] + "をやってみて～！"
			return a + b
		else
			key = getKey(like, @shumiDict)
			r = rand(@shumiDict[key].length)
			return like + "が好きだから、" + @shumiDict[key][r] + "をやってみて～！"
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
			return "好きな場所がよくわからんけど、" + @placeDict[key][q] + "に行ってみて～！"
		end
		ran = rand(@placeList.length)
		like = @placeList[ran]
		if @placeDict.keys.include?(like)
			a = like + "が好きだよね！"
			r = rand(@placeDict[like].length)
			b = "じゃあ、" + @placeDict[like][r] + "に行ってください！"
			return a + b
		else
			key = getKey(like, @placeDict)
			r = rand(@placeDict[key].length)
			return like + "が好きだから、" + @placeDict[key][r] + "に行ってみて～！"
		end			
	end

	def hope()
		aList = ["進み続けてさえいれば、遅くとも関係ない。", "目指すべき所に、近道は存在しない。", "この世界の内に望む変化に、あなた自身が成ってみせなさい。", "きっと成功してみせる、と決心する事が何よりも重要だ。", "打たないショットは、100％外れる。", "人間にとって最大の危険は、高い目標を設定して達成できないことではなく、低い目標を設定して達成してしまうことだ。", "木を植えるのに一番良かった時期は２０年前だった。二番目に良い時期は今だ。", "岸を見失う勇気がなければ、決して海を渡る事はできない", "人の心が思い描き信じられる事は、すべて実現可能である。", "幸せはもうすでに出来上がっているものじゃない。自分の行動が引き付けるものだ。"]
		ran = rand(aList.length)
		return aList[ran]
	end

	def conversation(inp)
		#check for key commands: #food #place #shumi
		if inp == "#food"
			return recFood()
		elsif inp == "#place" 
			return recPlace()
		elsif inp == "#shumi" 
			return recInterest()
		elsif inp == "#time"
			return "今、"  + Time.zone.now.to_s + " です！"
		elsif inp == "#face"
			return randomfaces()
		elsif inp == "#hope"
			return hope()
		elsif inp == "#random"
			return generateRandomComment(rand(10..20))
		elsif inp == "#common"
			return getCommonWords()
		elsif inp == "#commands"
			ans = "#food\t#place\t#shumi\t#time\t#face\t#face\t#hope\t#random\t#common"
			ender = "を入力してみてください！"
			return ans + ender
		elsif @greetings.include?(inp)
			return inp.to_s + "、" + @username + "ちゃん！"
		elsif @bye.include?(inp)
			return  @bye[ran] + "、" + @username + "ちゃん！"
		end

		inpList = tokenize_input(inp)
		inpList.each do |word|
			if @greetings.include?(word)
				return word.to_s + "、" + @username + "ちゃん！"
			end
			if @bye.include?(word)
				ran = rand(@bye.length)
				return  @bye[ran] + "、" + @username + "ちゃん！"
			end
		end

		result = YahooJA.keyphrase inp
		key_word = p result
		if key_word.nil?
			inpList = tokenize_input(inp)
			inpList.each do |word|
				if @words.include?(word)
					return generateRandomCommentWord(rand(10..20), word)
				end
			end
			return "言ってたことが分からない " + randomfaces()
		else
			inpList = key_word.keys
			inpList.each do |word|
				if @words.include?(word)
					return generateRandomCommentWord(rand(10..20), word)
				end
			end
			return "言ってたことが分からない " + randomfaces()
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
		ans = "あなたがよく使ってる言葉： "
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
