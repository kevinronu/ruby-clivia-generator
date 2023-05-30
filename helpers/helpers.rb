require "htmlentities"
require "terminal-table"

module Helpers
  def print_options(options)
    options.each.with_index do |option, index|
      print "#{index + 1}. #{option.capitalize}      "
    end
    puts ""
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

  def get_answer_option(menu:, options:, correct_answer:)
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

  def initial_menu
    list_options = ["random", "scores", "exit"]
    get_with_options(menu: list_options, options: list_options)
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
      score += get_with_number_options(menu: menu, options: options, correct_answer: correct_answer)
    end
    score
  end

  def scores_table
    table = Terminal::Table.new
    table.title = "Top Scores".colorize(:light_red)
    table.headings = ["Name".colorize(:light_blue), "Score".colorize(:light_green)]
    store = @storefile.map { |element| [element[:name].colorize(:cyan), element[:score]] }
    table.rows = store.sort_by { |element| -element[1] }

    table
  end

  def print_welcome
    puts ["###################################",
          "#   Welcome to Clivia Generator   #",
          "###################################"].join("\n").colorize(:light_yellow)
  end
end
