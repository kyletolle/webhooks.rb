require 'sinatra/base'
require 'json'
require 'dotenv'
Dotenv.load
require 'fastenv'
require_relative '../../random_number_generator'

class RandomNumberButton < Sinatra::Base
  configure do
    set :app_file, __FILE__
    set :port, ENV['PORT'] || 9090
  end

  get '/' do
    status 200

    number_sent_message =
      if params[:num]
        "<p>Sent a text with this random number: #{params[:num]}"
      else
        ''
      end

    return <<-HTML
<html>
<head><title>Random Number Button</title></head>
<body>
<h1>Send a Random Number in a Text Message</h1>
#{number_sent_message}
<form method="post" action="/">
<button type="submit" style="padding: 10px;">Generate a Random Number and Text It!</button>
</form>
</body>
</html>
    HTML
  end

  post '/' do
    generator     = RandomNumberGenerator.new
      .tap{|g| g.webhooks = %w{http://localhost:6000}}
    random_number = generator.generate
    redirect "/?num=#{random_number}"
  end

  run! if app_file == $0
end

