require 'httparty'
require 'erb'
require 'ostruct'

module Fluent
  class Fluent::IdobataOutput < Fluent::Output
    Fluent::Plugin.register_output('idobata', self)

    def initialize
      super
    end

    config_param :webhook_url, :string
    config_param :message_template, :string
    config_param :post_interval, :integer, :default => 1

    def configure(conf)
      super

      @erb = ERB.new(@message_template)
      @q = Queue.new
    end

    def start
      super

      @thread = Thread.new(&method(:post))
    rescue
      $log.warn "raises exception: #{$!.class}, '#{$!.message}"
    end

    def shutdown
      super

      Thread.kill(@thread)
    end

    def emit(tag, es, chain)
      es.each {|time, record|
        param = OpenStruct.new
        param.tag = tag
        param.time = time
        param.record = record

        @q.push param
      }

      chain.next
    end

    private
    
    def post
      loop do
        param = @q.pop
        tag = param.tag
        time = param.time
        record = param.record
        
        begin
          HTTParty.post(@webhook_url, :body => "body=#{@erb.result(binding)}")
          sleep(@post_interval)
        rescue
          $log.warn "raises exception: #{$!.class}, '#{$!.message}, #{param}'"
        end
      end
    end

  end
end
