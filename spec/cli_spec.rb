require "spec_helper"
RSpec.describe "my_help cli_spec.rb by aruba", type: :aruba do
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
    before(:each) {
      run_command("my_help init #{temp_dir}")
    }
    it "confとhelpsが:local_help_dirに保存される" do
      expect(last_command_started).to be_successfully_executed
      expect(File.exist?(File.join(temp_dir, ".my_help", ".my_help_conf.yml"))).to be_truthy
      expect(File.exist?(File.join(temp_dir, ".my_help", "example.org"))).to be_truthy
    end
    it ":editor/:extのsetupは，arubaでのrspecがわからなかったので，後で修正するようにputs"
    it "set :extで'.md'にすると，initしてもlistで表示されない"
  end
  context "set editor code" do
    include_context :uses_temp_dir
    before(:each) { FileUtils.mkdir(File.join(temp_dir, ".my_help")) }
    before(:each) { run_command("my_help set editor 'code' #{temp_dir}") }
    before(:each) { stop_all_commands }
    it "set editor code tmp_dirで．セットされる" do
      conf_file = File.join(temp_dir, ".my_help", ".my_help_conf.yml")
      expect(File.exist?(conf_file)).to be_truthy
      puts File.read(conf_file)
    end
  end
end
