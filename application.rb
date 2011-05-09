require 'rubygems'
require 'mongo_mapper'
require 'sinatra'

configure do
  APP_ENVIRONMENT = Sinatra::Application.environment
  MongoMapper.config = {APP_ENVIRONMENT => {'uri' => ENV['MONGOHQ_URL']}}
  MongoMapper.connect(APP_ENVIRONMENT)
end

class Muzak
  include MongoMapper::Document
  key :url , String, :required => true
  timestamps!
end

get '/' do
  redirect to(Muzak.sort(:created_at).last.url)
end

post '/' do
  url = Muzak.new({:url => params[:url] })
  if url.save!
    response.headers['Location'] = Muzak.sort(:created_at).last.url
  end
end
