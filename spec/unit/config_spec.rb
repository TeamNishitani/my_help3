require "pp"
require "fileutils"

module MyHelp
  RSpec.describe Config do
    describe "config" do
      let(:tmp_conf) {
        Config.new
      }
      it "default confを返す" do
        expect(tmp_conf.config[:ext]).to eq(".org")
      end
      it "default confに正しいkeyが設定されている" do
        # pp Config.new.config
        [:template_dir, :local_help_dir, :conf_file, :editor, :ext].each do |key|
          expect(tmp_conf.config).to have_key(key)
        end
      end
    end

    describe "configure" do
      let(:tmp_conf) {
        Config.new
      }
      it ":extに'.md'を正しく設定できる" do
        expect(tmp_conf.configure(ext: ".md")[:ext]).to eq(".md")
      end
      it "間違ったkey(:dir)を設定するとKeyErrorが返る" do
        file_path = "hoge"
        expect {
          tmp_conf.configure(dir: file_path)
        }.to raise_error(KeyError)
      end
    end

    shared_context "create config with path" do
    end

    describe "pathを指定してconfigure" do
      let(:path) {
        path = File.join(File.dirname(__dir__),
                         "../lib/templates")
      }
      let(:tmp_conf) {
        Config.new(path)
      }
      #      include_context "create config with path"
      it ":extに'.org'が正しく設定されている" do
        expect(tmp_conf.config[:ext]).to eq(".org")
      end
      it "pathに.my_help_conf.ymlを保存する" do
        tmp_conf.save_config()
        expect(File.exist?(File.join(path, ".my_help_conf.yml"))).to be_truthy
        FileUtils.rm(File.join(path, ".my_help_conf.yml"))
      end
    end
  end
end
