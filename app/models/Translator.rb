require 'easy_translate'
require 'Rails'
class Translator
	def initialize
		#set key
		EasyTranslate.api_key = 'AIzaSyCgB1FF8wY_-jhdHr97PFoAo_nJxstXdK4'
	end

	def translate(word)
		return EasyTranslate.translate(word, :from => :en, :to => :japanese)
	end

	def write_to_file()
		pName = "en.txt"
		reader = File.open(pName, "r:UTF-8")
		writer = File.open("jp.txt", "a:UTF-8")
		#writer = File.open("jp.txt", "w:UTF-8")
		reader.each_line do |line|
		  elements = line.split(" ")
		  words = elements[0] + " " + translate(elements[1]) + "\n"
		  writer.write(words)
		end
	end
end