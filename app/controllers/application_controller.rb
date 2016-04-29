require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "fwitter_secret"
  end

  get '/' do
    @tweets = Tweet.all
    @users = User.all
    erb :index
  end

  get '/tweet' do
    if session[:user_id]
      erb :tweet
    else
      redirect "/login"
    end
  end

  post '/tweet' do
    user = User.find_by(:user_id => session[:user_id])
    tweet = Tweet.new(:user => user, :status => params[:status])
    tweet.save
    redirect '/'
  end

  get '/users' do
    @users = User.all
    erb :users
  end
  
  get '/signup' do
    erb :signup
  end

  post '/sign-up' do 
    @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
    @user.save
    redirect '/login'
  end
  
  get '/login' do
    erb :login
  end
  
  post '/login' do
     user = User.find_by(:username => params[:username])
     if user
        session[:user_id] = user.id
        redirect "/"
     else
        redirect "/signup"
     end
  end
  
  get '/logout' do
    session.destroy
    redirect "/login"
  end
  
    helpers do
    def logged_in?
      session[:user_id]
    end
  end
  
    helpers do
    def logged_in?
      session[:user_id]
    end
  end
  
  
end
