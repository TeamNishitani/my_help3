module MyHelp
  class Init
    def initialize(dir = nil)
      dir ||= ENV["HOME"]
      @my_help_dir = File.join(dir, ".my_help")
    end

    def check_dir_exist
      File.exist?(@my_help_dir)
    end

    def check_conf_exist
      @my_help_conf = File.join(@my_help_dir, ".my_help_conf.yml")
      File.exist?(@my_help_conf)
    end

    def save_conf
      Config.new(@my_help_dir).save_config
    end

    def cp_templates
      conf = Config.new(@my_help_dir)
      target_dir = conf.config[:local_help_dir]
      src_dir = conf.config[:template_dir]
      ext = conf.config[:ext]
      Dir.glob(File.join(src_dir, "*#{ext}")).each do |file|
        FileUtils.cp(file, target_dir, verbose: true)
      end
    end
  end
end
