require "fileutils"

module MyHelp
  RSpec.describe Modify do
    let(:templates_path) {
      File.join(File.dirname(__FILE__),
                "../../lib/templates")
    }
    describe "振る舞い" do
      it "ヘルプをnewする" do
        help_name = "example_2"
        Modify.new(templates_path).new(help_name)
        target = File.join(templates_path, help_name + ".org")
        expect(File.exist?(target)).to be_truthy
      end
      it "ヘルプをdeleteする" do
        help_name = "example_2"
        Modify.new(templates_path).delete(help_name)
        target = File.join(templates_path, help_name + ".org")
        expect(File.exist?(target)).to be_falsy
      end
      it "ヘルプをeditする, system callなのでunit testではできない"
    end
  end
end
