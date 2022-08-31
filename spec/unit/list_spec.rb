module MyHelp
  RSpec.describe List do
    let(:templates_path) {
      File.join(File.dirname(__FILE__),
                "../../lib/templates")
    }

    describe "list" do
      it "ヘルプ名がないときは，全てのヘルプを表示" do
        expect(List.new(templates_path).list).to be_include("example")
      end
      it "ヘルプ名があるときは，その中の全てのitemを表示" do
        output = "* head"
        help_options = "example"
        expect(List.new(templates_path).list(help_options)).to be_include(output)
      end
    end
    describe "md extension" do
      it "拡張子がmdならそっちで動く" do
        expect(List.new(templates_path, ".md").list).to be_include("example.md")
      end
    end
  end
end
