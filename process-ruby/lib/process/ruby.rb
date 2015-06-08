require "process/ruby/version"
require "json"
require "csv"

module Process

  OUTPUT_FILE_NAME = "output.csv"

  def Process.process(field, folder)
    frequencies = {}

    Dir.glob(folder + "*.json") do |filename|
      file = IO.read(filename)
      data = JSON.parse(file)
      if not data.has_key?(field) then raise KeyError, "Field is missing" end
      value = data[field]
      if not value.is_a? String then raise TypeError, "Field is not a string" end
      frequencies[value] = frequencies.fetch(value, 0) + 1 unless value == ""
    end

    sorted_frequencies = Hash[frequencies.sort_by{|k, v| v}.reverse]

    CSV.open(OUTPUT_FILE_NAME, "wt") do |csv|
      sorted_frequencies.each do |k, v|
        csv << [k, v]
      end
    end

    return true
  end

end
