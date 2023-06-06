require "htmlentities"

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

  def check_answer(menu:, options:, correct_answer:)
    input = ""
    score = 0
    loop do
      menu.each_with_index { |element, index| puts "#{(index + 1).to_s.colorize(:light_cyan)}. #{element}" }
      print "> "
      input = gets.chomp
      if options.include?(input.to_i)
        if menu[input.to_i - 1] == correct_answer
          puts "Correct!"
          score += 10
        else
          puts "#{menu[input.to_i - 1].colorize(:light_black)}... Incorrect!\n" \
               "The correct answer was: #{correct_answer.colorize(:red)}"
        end
        break
      end
      puts "Invalid option, write only the number of the option"
    end
    score
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

  def questions_menu(results)
    coder = HTMLEntities.new
    score = 0
    results.each do |question|
      puts "Category: #{coder.decode(question[:category].colorize(:light_blue))} " \
           "| Difficulty: #{coder.decode(question[:difficulty].colorize(:blue))}\n" \
           "Question: #{coder.decode(question[:question]).colorize(:light_green)}"
      correct_answer = coder.decode(question[:correct_answer])
      array = []
      array << correct_answer
      question[:incorrect_answers].each { |element| array << coder.decode(element) }
      array.shuffle!
      menu = []
      options = []
      array.each_with_index do |element, index|
        menu << element
        options << (index + 1)
      end
      score += check_answer(menu: menu, options: options, correct_answer: correct_answer)
    end
    score
  end
end
