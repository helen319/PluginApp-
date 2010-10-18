require 'spec_helper'

describe "messages/index.html.erb" do
  before(:each) do
    assign(:messages, [
      stub_model(Message,
        :user_id => 1,
        :recipient_id => 1,
        :content => "MyText"
      ),
      stub_model(Message,
        :user_id => 1,
        :recipient_id => 1,
        :content => "MyText"
      )
    ])
  end

  it "renders a list of messages" do
    render
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyText".to_s, :count => 2)
  end
end
