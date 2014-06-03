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

def files_string(files)
  files.map{|f| "    #{f['file']} (#{f['type']})"}.join("\n")
end

def commit_string(c)
  "#{c['author']}@#{c['branch']}(#{c['raw_node'][0,7]}) #{c['timestamp']}\n#{c['message']}\n" + files_string(c['files'])
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
    message = commits.map{|c| commit_string c }.join("\n")
  end
  message.tap {|x| p pushover(x, title: title) }
end
