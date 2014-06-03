require 'sinatra'
require "uri"
require "net/http"

def pushover_settings
  { user:    'ykvA53kfTZmElFLxnfe69HMyGNK61r',
    token:   'aFRF8JJgnB5xmdaK37KLh1VkMMFgW6' }
end

before do
 request.body.rewind
 @request_payload = request.body.read
end

def pushover(message, **args)
  push_params = pushover_settings.merge(args).merge(message: message)
  uri = URI.parse('https://api.pushover.net/1/messages.json')
  Net::HTTP.post_form(uri, push_params)
end

get '/' do
  params.inspect.tap {|x| pushover(x) }
end

post '/' do
  params.inspect.tap {|x| pushover(x) }
end

post '/bitbucket' do
  @request_payload.tap {|x| p pushover(x) }
end
