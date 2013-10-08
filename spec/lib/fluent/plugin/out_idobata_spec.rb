require 'spec_helper'

describe do
  let(:driver) {Fluent::Test::OutputTestDriver.new(Fluent::IdobataOutput, 'test.metrics').configure(config)}
  let(:instance) {driver.instance}

  describe 'config' do
    let(:config) {
      %[
      webhook_url         https://idobata/web_hook/url
      message_template    field1 value: <%= record["field1"] %>
      ]
    }
    
    context do
      subject {instance.webhook_url}
      it{should == 'https://idobata/web_hook/url'}
    end

    context do
      subject {instance.message_template}
      it{should == 'field1 value: <%= record["field1"] %>'}
    end

  end
  
  describe 'emit' do
    let(:record) {{ 'field1' => 50, 'otherfield' => 99}}
    let(:time) {0}
    let(:posted) {
      d = driver
      mock(HTTParty).post('https://idobata/web_hook/url', :body => 'body=field1 value: 50')
      d.emit(record, Time.at(time))
      d.run
    }

    context do
      let(:config) {
        %[
      webhook_url         https://idobata/web_hook/url
      message_template    field1 value: <%= record["field1"] %>
        ]
      }

      subject {posted}
      it{should_not be_nil}
    end

  end

end