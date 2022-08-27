require "tmpdir"
require "fileutils"
# [[https://gist.github.com/sue445/d840d6f68771a14a48fc][Example of using temporary directory at rspec]]

module MyHelp
  RSpec.describe Init do
    shared_context :uses_temp_dir do
      around do |example|
        Dir.mktmpdir("rspec-") do |dir|
          @temp_dir = dir
          example.run
        end
      end

      attr_reader :temp_dir
    end

    describe "example of uses_temp_dir" do
      include_context :uses_temp_dir

      it "should create temp_dir" do
        expect(Dir.exists?(temp_dir)).to be true
      end

      it "can create file in temp_dir" do
        temp_file = "#{temp_dir}/temp.txt"

        File.open(temp_file, "w") do |f|
          f.write("foo")
        end

        expect(File.read(temp_file)).to eq "foo"
      end
    end

    describe "振る舞い" do
      include_context :uses_temp_dir
      it "check_dir_existで~/.my_helpディレクトリがないことを確認" do
        expect(Init.new(temp_dir).check_dir_exist).not_to be true
      end
      it "check_conf_existで~/.my_help/.my_help_conf.ymlがないことを確認" do
        FileUtils.mkdir(File.join(temp_dir, ".my_help"))
        expect(Init.new(temp_dir).check_conf_exist).not_to be true
      end
      it ":editorと:extをセットする" do
        puts "interactive for Thor"
      end
      it "save_confでconfigを.my_help_conf.ymlにsaveする" do
        FileUtils.mkdir(File.join(temp_dir, ".my_help"))
        Init.new(temp_dir).save_conf
        target = File.join(temp_dir, ".my_help", ".my_help_conf.yml")
        expect(File).to exist(target)
        puts File.read(target)
      end
      it "cp_templatesでtemplatesの*.extをcpする" do
        # assume :ext = 'org'
        FileUtils.mkdir(File.join(temp_dir, ".my_help"))
        Init.new(temp_dir).cp_templates
        target = File.join(temp_dir, ".my_help")
        expect(File).to exist(File.join(target, "example.org"))
      end
    end
  end
end
