class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :views, Proc.new { File.join(root, "../views/") }

  configure do
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :home
  end

  get '/registrations/signup' do
    #renders(present/submit) signup form for user to fill out
    erb :'/registrations/signup'
  end

  post '/registrations' do
    #assigns users values to params of instance of User class 
    @user = User.new(name: params["name"], email: params["email"], password: params["password"])
    @user.save
    session[:user_id] = @user.id
    #When that form gets submitted, a POST request is sent to a route defined in the controller
    # Gets the new user's name, email, and password from the params hash.
    # Uses that info to create and save a new instance of User. For example: User.create(name: params[:name], email: params[:email], password: params[:password]).
    # Signs the user in once they have completed the sign-up process.
    redirect '/users/home'
  end

  get '/sessions/login' do
    erb :'sessions/login'
  end

  post '/sessions' do
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user
      session[:user_id] = @user.id
      redirect '/users/home'
    end
    redirect '/sessions/login'
  end

  get '/sessions/logout' do
    session.clear
    redirect '/'
  end

  get '/users/home' do
    @user = User.find(session[:user_id])
    erb :'/users/home'
  end
end
