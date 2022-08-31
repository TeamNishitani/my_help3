require "spec_helper"
require "aruba/api"
RSpec.describe "my_help cli_spec.rb by aruba", type: :aruba do
  #  include_context "uses aruba API"
  shared_context :uses_temp_dir do
    around do |example|
      Dir.mktmpdir("rspec-") do |dir|
        @temp_dir = dir
        example.run
      end
    end

    attr_reader :temp_dir
  end
  context "version option" do
    before(:each) { run_command("my_help version") }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output("1.0b") }
  end
  context "no option" do
    before(:each) { run_command("my_help") }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output(/my_help help/) }
  end

  context "init option" do
    include_context :uses_temp_dir
    before(:each) { run_command("my_help init #{temp_dir}") }

    it "confとhelpsが:local_help_dirに保存される" do
      type ".md\n"
      stop_all_commands
      conf_file = File.join(temp_dir, ".my_help", ".my_help_conf.yml")
      expect(File.exist?(conf_file)).to be_truthy
      puts File.read(conf_file)
      example_file = File.join(temp_dir, ".my_help", "example.md")
      expect(File.exist?(example_file)).to be_truthy
    end
    it ":editor/:extの複数setupは，arubaでのrspecがわからなかったので，後で修正するようにputs"
  end

  context "set editor code" do
    include_context :uses_temp_dir
    before(:each) { FileUtils.mkdir(File.join(temp_dir, ".my_help")) }
    before(:each) { run_command("my_help set editor 'code' #{temp_dir}") }
    before(:each) { stop_all_commands }
    it "my_help/.my_help_conf.ymlに:editor = 'code'がセットされる" do
      conf_file = File.join(temp_dir, ".my_help", ".my_help_conf.yml")
      expect(File.exist?(conf_file)).to be_truthy
      puts File.read(conf_file)
    end
  end
  describe "# run_command でinteractiveにできるサンプル" do
    context "cat helloを試す" do
      before { run_command "cat" }

      after { all_commands.each(&:stop) }

      it "type HelloでHelloが返る" do
        type "Hello"
        type "\u0004"
        expect(last_command_started).to have_output "Hello"
        type "Hello"
        type "\u0004"
        expect(last_command_started).to have_output "Hello"
      end
    end
  end

  describe "# run_command interfactiveの例" do
    context "hello 'bob'に反応する" do
      before { run_command("my_help hello") }
      #      before(:each) { stop_all_commands }

      after { all_commands.each(&:stop) }

      it "type bobでHello bobが返る" do
        type "bob\n"
        #        type "\u0004"
        close_input
        expect(last_command_started).to have_output "Hello bob."
      end
    end
  end
end
