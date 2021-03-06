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
    let(:time) {0}
    context 'without semicolon in body' do
      let(:record1) {{ 'field1' => 50, 'otherfield' => 99}}
      let(:record2) {{ 'field1' => 150, 'otherfield' => 199}}
      let(:posted) {
        d = driver

        expect(HTTParty).to receive(:post).with('https://idobata/web_hook/url', :body => "body=#{CGI.escape('field1 value: 50')}")
        expect(HTTParty).to receive(:post).with('https://idobata/web_hook/url', :body => "body=#{CGI.escape('field1 value: 150')}")

        d.emit(record1, Time.at(time))
        d.emit(record2, Time.at(time))
        d.run
      }

      context do
        let(:config) {
          %[
        webhook_url         https://idobata/web_hook/url
        message_template    field1 value: <%= record["field1"] %>
        post_interval       0
          ]
        }

        subject {posted}
        it{should_not be_nil}
      end
    end
    context 'without semicolon in body' do
      let(:record1) {{ 'field1' => ';te;st;', 'otherfield' => 99}}
      let(:posted) {
        d = driver

        expect(HTTParty).to receive(:post).with('https://idobata/web_hook/url', :body => "body=#{CGI.escape('field1 value: ;te;st;')}")

        d.emit(record1, Time.at(time))
        d.run
      }

      context do
        let(:config) {
          %[
        webhook_url         https://idobata/web_hook/url
        message_template    field1 value: <%= record["field1"] %>
        post_interval       0
          ]
        }

        subject {posted}
        it{should_not be_nil}
      end
    end

  end

end