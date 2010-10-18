require 'spec_helper'

describe "messages/new.html.erb" do
  before(:each) do
    assign(:message, stub_model(Message,
      :new_record? => true,
      :user_id => 1,
      :recipient_id => 1,
      :content => "MyText"
    ))
  end

  it "renders new message form" do
    render

    rendered.should have_selector("form", :action => messages_path, :method => "post") do |form|
      form.should have_selector("input#message_user_id", :name => "message[user_id]")
      form.should have_selector("input#message_recipient_id", :name => "message[recipient_id]")
      form.should have_selector("textarea#message_content", :name => "message[content]")
    end
  end
end
