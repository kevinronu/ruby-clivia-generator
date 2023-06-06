require_relative "classes/clivia_generator"

filename = ARGV.shift

if filename.nil?
  filename = "scores.json"
else
  File.write(filename, "") unless File.exist?(filename)
end

trivia = CliviaGenerator.new(filename)
trivia.start