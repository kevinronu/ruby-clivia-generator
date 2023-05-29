require "json"

module JsonParser
  def parse_scores(filename)
    file = File.read(filename)
    raise Errno::ENOENT if file == ""

    JSON.parse(file, symbolize_names: true)
  end

  def export_scores(filename, data)
    File.write(filename, data.to_json)
  end
end
