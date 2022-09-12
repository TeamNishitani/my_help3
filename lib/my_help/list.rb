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
      info[:name] = File.basename(file).split(".")[0]
      info[:items] = Org2Hash.new(File.read(file)).contents

      return info
    end

    def list_helps()
      files = File.join(@path, "*#{@ext}")
      Dir.glob(files).inject("") do |out, file|
        help_info = read_help(file)
        out << "%10s: %s\n" % [help_info[:name],
                               help_info[:desc]]
      end
    end

    def list_help_with(name, item)
      if item == nil
        help_info = read_help(File.join(@path, name + @ext))
        #        p help_info[:items]
        output = ""
        help_info[:items].each_pair do |item, val|
          output << "- %s\n" % item
        end
      else
        ""
      end
      return output
    end
  end
end
