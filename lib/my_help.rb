# frozen_string_literal: true
require "thor"
require "fileutils"
require "pp"
require "yaml"
require "command_line/global"
require_relative "my_help/version"
require_relative "my_help/list"
require_relative "my_help/config"
require_relative "my_help/modify"
require_relative "my_help/init"

module MyHelp
  class Error < StandardError; end

  # Your code goes here...
  class CLI < Thor

    # THOR to SILENCE DEPRECATION
    # https://qiita.com/tbpgr/items/5edb1454634157ff816d
    class << self
      def exit_on_failure?
        true
      end
    end

    desc "version", "show version"

    def version
      puts VERSION
    end

    desc "init", "init"

    def init(*args)
      config = Config.new(help_dir(args))
      #config.ask_default
      init = Init.new(config.config)
      raise "Local help dir exist." if init.check_dir_exist
      puts "Choose default markup '.org' [Y or '.md']? "
      responce = $stdin.gets.chomp
      config.configure(:ext => responce) unless responce.upcase[0] == "Y"
      init.mk_help_dir
      config.save_config
      init.cp_templates
      puts "If you want change editor use my_help set editor 'code'"
    end

    desc "set [:key] [VAL]", "set editor or ext"

    def set(*args)
      config = Config.new(help_dir(args))
      config.configure(args[0].to_sym => args[1])
      config.save_config
      conf_file_path = config.config[:conf_file]
      puts "conf_file_path: %s" % conf_file_path
      puts File.read(conf_file_path)
    end

    desc "list", "list helps"

    def list(*args)
      config = Config.new(help_dir(args))
      puts List.new(config.config[:local_help_dir],
                    config.config[:ext]).list(*args.shift)
    end

    desc "edit", "edit helps"

    def edit(*args)
      c = Config.new(help_dir(args))
      help_name = args[0]
      p help_file = File.join(c.config[:local_help_dir], help_name + c.config[:ext])
      p comm = "#{c.config[:editor]} #{help_file}"
      c = command_line(comm)
      puts c
    end

    desc "hello", "hello"

    def hello
      name = $stdin.gets.chomp
      puts("Hello #{name}.")
    end

    no_commands {
      def help_dir(args)
        args[0] = "" if args.size == 0
        help_dir = args[-1]
        help_dir = ENV["HOME"] unless File.exist?(help_dir)
        return help_dir
      end
    }
  end
end
