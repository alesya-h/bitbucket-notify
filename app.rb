require 'sinatra'
require 'uri'
require 'net/http'
require 'json'

def pushover_settings
  { user:    'ykvA53kfTZmElFLxnfe69HMyGNK61r',
    token:   'aFRF8JJgnB5xmdaK37KLh1VkMMFgW6' }
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
  data = JSON.parse params['payload']
  title = data["repository"]["name"]
  if (commits = data["commits"]).empty?
    message = data.to_s
  else
    message = commits.map do |c|
      "#{c['author']}:#{c['branch']}:#{c['node']}\n#{c['message']}\n"
    end.join("\n")
  end
  message.tap {|x| p pushover(x, title: title) }
end
