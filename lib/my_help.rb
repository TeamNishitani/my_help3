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
      config = get_config(args)
      #config.ask_default
      init = Init.new(config.config)
      raise "Local help dir exist." if init.check_dir_exist
      puts "Choose default markup '.org' [Y or .md]? "
      responce = $stdin.gets.chomp
      config.configure(:ext => responce) unless responce.upcase[0] == "Y"
      init.mk_help_dir
      config.save_config
      init.cp_templates
      puts "If you want change editor use my_help set editor code."
    end

    desc "set [:key] [VAL]", "set editor or ext"

    def set(*args)
      config = get_config(args)
      config.configure(args[0].to_sym => args[1])
      config.save_config
      conf_file_path = config.config[:conf_file]
      puts "conf_file_path: %s" % conf_file_path
      puts File.read(conf_file_path)
    end

    desc "list", "list helps"

    def list(*args)
      config = get_config(args).config
      puts List.new(config[:local_help_dir],
                    config[:ext]).list(*args.shift)
    end

    desc "edit [HELP]", "edit help"

    def edit(*args)
      c = get_config(args).config
      help_name = args[0]
      Modify.new(c).edit(help_name)
      #     puts res.stdout
    end

    desc "new [HELP]", "mk new HELP"

    def new(*args)
      c = get_config(args).config
      help_name = args[0]
      help_file = File.join(c[:local_help_dir], help_name + c[:ext])
      Modify.new(c).new(help_file)
      #     puts res.stdout
    end

    desc "delete [HELP]", "delete HELP"

    def delete(*args)
      c = get_config(args).config
      help_name = args[0]
      help_file = File.join(c[:local_help_dir], help_name + c[:ext])
      puts "Are you sure to delete #{help_file}? [YN]"
      responce = $stdin.gets.chomp
      if responce.upcase[0] == "Y"
        Modify.new(c).delete(help_file)
      else
        puts "Leave #{help_file} exists."
      end
    end

    desc "hello", "hello"

    def hello
      name = $stdin.gets.chomp
      puts("Hello #{name}.")
    end

    no_commands {
      def get_config(args)
        # Rspec環境と，実動環境の差をここで吸収
        # RSpecではargsの最後にtemp_dirをつけているから
        args[0] = "" if args.size == 0
        help_dir = args[-1]
        help_dir = ENV["HOME"] unless File.exist?(help_dir)
        return Config.new(help_dir)
      end
    }
  end
end
