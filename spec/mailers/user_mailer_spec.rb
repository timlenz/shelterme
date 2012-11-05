require "spec_helper"

describe UserMailer do
  describe "password_reset" do
    let(:mail) { UserMailer.password_reset }

    subject { mail }

    it "renders the headers" do
      mail.subject.should eq("Password reset")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
