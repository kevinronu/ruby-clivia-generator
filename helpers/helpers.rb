require "htmlentities"
require "colorize"

module Helpers
  def print_options(options)
    puts options.join(" | ")
  end

  def get_with_options(prompt:, options:, msg: "", capitalize: false)
    puts prompt
    print_options(options)
    print "> "
    input = gets.chomp.downcase
    input = input.capitalize if capitalize
    until options.include?(input)
      puts msg
      print_options(options)
      print "> "
      input = gets.chomp.downcase
      input = input.capitalize if capitalize
    end
    puts ""
    input
  end

  def show_options(options_text:, options_numbers:, correct_answer:)
    input = ""
    score = 0
    loop do
      options_text.each_with_index { |element, index| puts "#{(index + 1).to_s.colorize(:light_cyan)}. #{element}" }
      print "> "
      input = gets.chomp
      if options_numbers.include?(input.to_i)
        score += 10 if check_answer(options_text: options_text, input: input, correct_answer: correct_answer)
        break
      end
      puts "Invalid option, write only the number of the option"
    end
    score
  end

  def check_answer(options_text:, input:, correct_answer:)
    if options_text[input.to_i - 1] == correct_answer
      puts "Correct!"
      true
    else
      puts "#{options_text[input.to_i - 1].colorize(:light_black)}... Incorrect!\n" \
           "The correct answer was: #{correct_answer.colorize(:red)}"
      false
    end
  end

  def menu
    puts "Random | Scores | Exit"
    input = ""
    while input.empty?
      print "> "
      input = gets.chomp.capitalize
    end
    input
  end

  def decode_string(string:, color: nil)
    coder = HTMLEntities.new
    string = coder.decode(string)
    color ? string.colorize(color) : string
  end

  def show_questions(questions)
    score = 0
    questions.each do |question|
      puts "Category: #{decode_string(string: question[:category], color: :light_blue)} " \
           "| Difficulty: #{decode_string(string: question[:difficulty], color: :blue)}\n" \
           "Question: #{decode_string(string: question[:question], color: :light_green)}"
      correct_answer = decode_string(string: question[:correct_answer])
      array = []
      array << correct_answer
      question[:incorrect_answers].each { |element| array << decode_string(string: element) }
      array.shuffle!
      options_text = []
      options_numbers = []
      array.each_with_index do |element, index|
        options_text << element
        options_numbers << (index + 1)
      end
      score += show_options(options_text: options_text, options_numbers: options_numbers,
                            correct_answer: correct_answer)
    end
    score
  end
end
