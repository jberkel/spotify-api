require File.join(File.dirname(__FILE__), 'spec_helper')

require 'rack/test'
require 'jotify'
require 'api'

require 'sinatra'
set :environment, :test

describe 'Api' do
  
  def app() Sinatra::Application end
    
  before do  
    @jotify = jotify = mock('Jotify')
    Sinatra::Application.send(:define_method, :jotify) { jotify }
  end
  
  describe "/artists" do
    it "searches by artist name" do
      @jotify.stub!(:search).and_return(Jotify::Result.new)
      get '/artists', :name=>'The Kinks'
      last_response.should be_ok
      last_response.content_type.should == 'application/json'      
      JSON.parse(last_response.body).should == {"status"=>"OK", "result"=>[]}
    end      
  end
  
  describe "/tracks" do
     it "searches by track name" do
       @jotify.stub!(:search).and_return(Jotify::Result.new)
       get '/tracks', :name=>'Waterloo Sunset'
       last_response.should be_ok
       last_response.content_type.should == 'application/json'      
       JSON.parse(last_response.body).should == {"status"=>"OK", "result"=>[]}
     end      
  end
  
  describe "/albums" do
    it "searches by album name" do
      @jotify.stub!(:search).and_return(Jotify::Result.new)
      get '/albums', :name=>'Something Else'
      last_response.should be_ok
      last_response.content_type.should == 'application/json'      
      JSON.parse(last_response.body).should == {"status"=>"OK", "result"=>[]}
    end      
  end
  
  
  
end