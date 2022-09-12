module MyHelp
  RSpec.describe List do
    let(:templates_path) {
      File.join(File.dirname(__FILE__),
                "../../lib/templates")
    }

    describe "list" do
      it "ヘルプ名がないときは，全てのヘルプとその簡単な内容説明を表示" do
        output = "example: - help_title"
        expect(List.new(templates_path).list).to be_include(output)
      end
      it "ヘルプ名があるときは，その中の全てのitemを表示" do
        output = "head"
        help_options = "example"
        expect(List.new(templates_path).list(help_options)).to be_include(output)
      end
      it "item名があるときは，そのcontentを表示" do
        output = "- content_b"
        help_options = "example b_item"
        expect(List.new(templates_path).list(help_options)).to be_include(output)
      end
    end
    describe "md extension" do
      it "拡張子がmdならそっちで動く"
    end
  end
end
