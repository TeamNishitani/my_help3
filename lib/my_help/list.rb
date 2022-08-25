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

    def list_helps()
      files = File.join(@path, "*#{@ext}")
      Dir.glob(files).inject("") do |out, file|
        out << File.basename(file) + "\n"
      end
    end

    def list_help_with(name, item)
      if item == nil
        File.read(File.join(@path, name + @ext))
        #pp Org2Yaml.new()
      else
        ""
      end
    end
  end
end
