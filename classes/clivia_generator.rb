require_relative "../handlers/json_parser"
require_relative "../helpers/helpers"
require_relative "../services/sessions"
require_relative "presenter"
require "colorize"

class CliviaGenerator
  include JsonParser
  include Helpers
  include Services
  include Presenter

  def initialize(filename)
    @filename = filename
    @name = "Anonymous"
    @score = 0
    @token = nil
    @questions = []
    @storefile = parse_scores(filename)
    @first_session = true # To know if it is the first time you play
  rescue Errno::ENOENT
    File.write(filename, "[]")
    @storefile = parse_scores(filename)
  end

  def start
    print_welcome
    action = menu
    until action == "Exit"
      begin
        case action
        when "Random" then ask_questions(@first_session)
        when "Scores" then puts print_score_table
        else puts "Invalid Action"
        end
        action = menu
      rescue HTTParty::ResponseError => e
        parsed_error = JSON.parse(e.message, symbolize_names: true)
        puts parsed_error
      end
    end
    puts "Thanks for using Clivia Generator".colorize(:light_yellow)
  end

  def ask_questions(first_session)
    if first_session
      first_load_questions
      @first_session = false
    else
      @questions = Sessions.using_session_token(@token)[:results]
    end
    @score = show_questions(@questions)
    puts "Well done! Your score is #{@score.to_s.colorize(:light_magenta)}\n#{'-' * 50}"
    option = get_with_options(prompt: "Do you want to save your score?", msg: "Invalid option, write only Y or N",
                              options: ["Y", "N"], capitalize: true)
    save if option == "Y"
  end

  def save
    puts "Type the name to assign to the score"
    print "> "
    input = gets.chomp
    @name = input unless input == ""
    @storefile << { name: @name, score: @score }
    export_scores(@filename, @storefile)
  end

  def first_load_questions
    @token = Sessions.retrieve_session_token[:token]
    Sessions.reset_session_token(@token)
    @questions = Sessions.using_session_token(@token)[:results]
  end
end
