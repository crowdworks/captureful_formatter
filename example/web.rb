require 'sinatra'
require 'haml'

Tweet = Struct.new(:body, :tweeted_at)
@@tweets = []

get '/' do
  redirect to('/tweets')
end

get '/tweets' do
  haml :index, locals: {tweets: @@tweets}
end

post '/tweets' do
  @@tweets.unshift Tweet.new(params[:body], Time.now.to_s)
  redirect to('/tweets')
end

__END__

@@ layout
!!!
%html
  %head
    %title sample app
  %body
    %header
      %h1 Monology
    %section
      = yield
    %footer


@@ index
= haml :_form
- tweets.each do |tweet|
  = haml :tweet, locals: {tweet: tweet}

@@ tweet
.tweet
  %h2= tweet.body
  .tweeted_at= tweet.tweeted_at

@@ _form
%form{action: "/tweets", method: "post"}
  What's happening?:
  %br
  %textarea{name: "body"}
  %br
  %input{type: "submit", value:"tweet"}
