require "yaml"

module MyHelp

  # make @config from default and load yaml
  # as shown
  # https://stackoverflow.com/questions/6233124/where-to-place-access-config-file-in-gem
  class Config
    # Configuration defaults
    def initialize(conf_path = nil)
      conf_path ||= File.join(ENV["HOME"], ".my_help")
      @config = {
        template_dir: File.expand_path("../templates", __dir__),
        local_help_dir: File.join(conf_path),
        conf_file: File.join(conf_path, ".my_help_conf.yml"),
        editor: ENV["EDITOR"] || "emacs",
        ext: ".org",
      }
      @valid_config_keys = @config.keys
      configure_with(@config[:conf_file])
      #      YAML.dump(@config, File.open(@config[:conf_file], 'w'))
      # no good for multiple testers.
    end

    # Configure through hash
    def configure(opts = nil)
      return if opts == nil
      opts.each do |k, v|
        if @valid_config_keys.include? k.to_sym
          @config[k.to_sym] = v
        else
          raise KeyError.new("Error: keyword '#{k}' is invalid",
                             receiver: @config,
                             key: k)
        end
      end
      @config
    end

    # Configure through yaml file
    def configure_with(path)
      begin
        config = YAML.safe_load(IO.read(path),
                                permitted_classes: [Symbol])
      rescue Errno::ENOENT => e
        $stderr.puts "WARNING: #{e.message}.\nUsing default conf."
      rescue Psych::SyntaxError => e
        $stderr.puts "WARNING: #{e}.\nUsing default conf."
      end
      configure(config)
    end

    # save config in  @config[:conf_file]
    def save_config(path = nil)
      path ||= @config[:conf_file]
      File.write(path, YAML.dump(config))
    end

    attr_reader :config
  end
end
