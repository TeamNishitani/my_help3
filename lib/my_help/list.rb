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
      info[:items] = []
      m = []
      head = false
      File.readlines(file).each do |line|
        if head
          info[:desc] = line.chomp
          head = false
        end
        head = true if m = line.match(/^\* head/)
        if m = line.match(/^\* (.+)/)
          info[:items] << m[1]
        end
      end

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
        help_info[:items].each do |item|
          next if item == "head" or item == "license"
          output << "- %s\n" % item
        end
      else
        ""
      end
      return output
    end
  end
end
