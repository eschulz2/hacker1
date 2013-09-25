enable :sessions
######################GET###############

get '/' do
  @posts = Post.all
  erb :index
end

get '/post/:id' do
  @post = Post.find(params[:id])
  @author = @post.user
  @comments = @post.comments
  erb :post
end

get '/user/:id' do 
  @user = User.find(params[:id])
  erb :user
end

get '/user/:id/posts' do
  @user = User.find(params[:id])
  @posts = @user.posts
  erb :index
end

get '/user/:id/comments' do
  @user = User.find(params[:id])
  @comments = @user.comments
  erb :comments
end

get '/login' do
  erb :login
end

get '/logout' do
  session.clear
  redirect to '/'
end


######################POST###############


post '/comment/:post_id' do
  if current_user
    Comment.create(text: params[:comment],user_id: current_user.id, post_id: params[:post_id])
    redirect to "/post/#{params[:post_id]}"
  else
    @error_attempted_comment = "You have to be logged in to comment."
    erb :login
  end
end

post '/login' do
  user = User.authenticate(params[:user])

  if user
    session[:user_id] = user.id
    redirect to '/'
  else
    @error_login = "username and password do not match"
    erb :login
  end

end

post '/signup' do
  user = User.create(params[:user])
  @error_signup = user.errors.full_messages

  if @error_signup.any?
    @error_signup = @error_signup.join(", ")
    erb :login
  else
    session[:user_id] = user.id
    redirect to '/'
  end

end
