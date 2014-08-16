# fluent-plugin-idobata

## Output

Plugin to send message to 'idobata'

### What's 'idobata'

'idobata' is VERY GREAT chat tool for team development on Web.

see: https://idobata.io

### Configure

````
<store>
  type idobata
  webhook_url          https://idobata/web_hook/url
  message_template     field1 is <%= record['field1'] %> !
</store>
````

- idobata_url
 - Your idobata webhook url
- message_template
 - You can use erb notation
 - send message to idobata
- (optional)post_interval
 - Interval of post to idobata

#### example

For messages such as: {"field1":300, "field2":20, "field3diff":-30}

send 'field1 is 300 !' message to your idobata room

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## releases

- 2013/10/09 0.0.0 1st release
- 2014/01/21 0.0.1 Support post interval
