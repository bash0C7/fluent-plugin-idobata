require 'httparty'
require 'erb'

module Fluent
  class Fluent::IdobataOutput < Fluent::Output
    Fluent::Plugin.register_output('idobata', self)

    def initialize
      super
    end

    config_param :webhook_url, :string
    config_param :message_template, :string

    def configure(conf)
      super

      @erb = ERB.new(@message_template)
    end

    def start
      super

    end

    def shutdown
      super

    end

    def emit(tag, es, chain)
      es.each {|time,record|
        HTTParty.post(@webhook_url, :body => "body=#{@erb.result(binding)}")
      }

      chain.next
    end
  end
end
