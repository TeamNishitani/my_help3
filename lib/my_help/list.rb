require_relative "./org2yml"

module MyHelp
  # Your code goes here...
  class List
    def initialize(path = "", ext = ".org")
      @path = path
      @ext = ext
    end

    def list(help_options = "")
      name, item = help_options.split(" ")
      if item == nil && name == nil
        list_helps()
      else
        list_help_with(name, item)
      end
    end

    def read_help(file)
      info = {}
      info[:items] = Org2Hash.new(File.read(file)).contents
      info[:name] = File.basename(file).split(".")[0]
      return info
    end

    def list_helps()
      files = File.join(@path, "*#{@ext}")
      Dir.glob(files).inject("") do |out, file|
        help_info = read_help(file)
        out << "%10s: %s\n" % [help_info[:name],
                               help_info[:items]["head"].split("\n")[0]]
      end
    end

    def list_help_with(name, item)
      @help_info = read_help(File.join(@path, name + @ext))
      output = ""

      if item == nil
        @help_info[:items].each_pair do |item, val|
          item, desc = item.split(":")
          desc ||= ""
          output << "- %20s : %s\n" % [item, desc]
        end
      else
        output << find_near(item)
      end
      return output
    end

    def find_near(input_item)
      candidates = []
      @help_info[:items].each_pair do |item, val|
        candidates << item if item.include?(input_item)
      end
      if candidates.size == 0
        "No similar item name with : #{input_item}"
      else
        contents = candidates.collect do |near_item|
          @help_info[:items][near_item]
        end
        contents.join("\n")
      end
    end
  end
end
