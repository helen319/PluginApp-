require 'spec_helper'

describe "messages/edit.html.erb" do
  before(:each) do
    @message = assign(:message, stub_model(Message,
      :new_record? => false,
      :user_id => 1,
      :recipient_id => 1,
      :content => "MyText"
    ))
  end

  it "renders the edit message form" do
    render

    rendered.should have_selector("form", :action => message_path(@message), :method => "post") do |form|
      form.should have_selector("input#message_user_id", :name => "message[user_id]")
      form.should have_selector("input#message_recipient_id", :name => "message[recipient_id]")
      form.should have_selector("textarea#message_content", :name => "message[content]")
    end
  end
end
