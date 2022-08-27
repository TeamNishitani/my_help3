require "spec_helper"
RSpec.describe "my_help", type: :aruba do
  context "version option" do
    before(:each) { run_command("my_help version") }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output(/1.0b/) }
  end
end
