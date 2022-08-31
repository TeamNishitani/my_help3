module MyHelp
  class Modify
    def initialize(conf)
      @conf = conf
    end

    def new(help_file)
      target = help_file
      source = File.join(@conf[:template_dir], "example.org")
      FileUtils.cp(source, target, verbose: @conf[:verbose])
    end

    def delete(help_file)
      FileUtils.rm(help_file, verbose: @conf[:verbose])
    end

    def edit(help_name)
      p help_file = File.join(@conf[:local_help_dir],
                              help_name + @conf[:ext])
      p comm = "#{@conf[:editor]} #{help_file}"
      system(comm)
    end
  end
end
