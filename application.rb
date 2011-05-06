require 'rubygems'
require 'mongo_mapper'
require 'sinatra'

configure do
  MongoMapper.config = {APP_ENVIRONMENT => {'uri' => ENV['MONGOHQ_URL']}}
  MongoMapper.connect(APP_ENVIRONMENT)
  DEFAULT_ROOM = 'http://muzak.heroku.com/rooms/bd3b67'
end

class Muzak
  include MongoMapper::Document
  key :url , String, :required => true
end

get '/' do
  url = Muzak.last.url || DEFAULT_ROOM
  redirect to(Muzak.last.url)
end

post '/' do
  url = Muzak.create({:url => params[:url] })
  url.save
end

