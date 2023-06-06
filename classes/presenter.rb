require "terminal-table"

module Presenter
  def print_welcome
    puts ["###################################",
          "#   Welcome to Clivia Generator   #",
          "###################################"].join("\n").colorize(:light_yellow)
  end

  def print_score_table
    table = Terminal::Table.new
    table.title = "Top Scores".colorize(:light_red)
    table.headings = ["Name".colorize(:light_blue), "Score".colorize(:light_green)]
    store = @storefile.map { |element| [element[:name].colorize(:cyan), element[:score]] }
    table.rows = store.sort_by { |element| -element[1] }
    table
  end
end
