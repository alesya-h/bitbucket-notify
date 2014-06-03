require 'sinatra'
require "uri"
require "net/http"
 
handler = lambda do
  data = params.inspect
  form_data = {
    user:    'ykvA53kfTZmElFLxnfe69HMyGNK61r',
    message: data,
    token:   'aFRF8JJgnB5xmdaK37KLh1VkMMFgW6'
  }
  Net::HTTP.post_form(URI.parse('https://api.pushover.net/1/messages.json'), form_data)
  data
end

get '/', &handler
post '/', &handler
