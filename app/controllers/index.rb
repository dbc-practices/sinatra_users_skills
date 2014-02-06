get '/' do
  # render home page
  @users = User.all
  @id = session[:user_id]
  erb :index
end

#----------- SESSIONS -----------

get '/sessions/new' do
  # render sign-in page
  @email = nil
  erb :sign_in
end

post '/sessions' do
  # sign-in
  @email = params[:email]
  user = User.authenticate(@email, params[:password])
  if user
    # successfully authenticated; set up session and redirect
    session[:user_id] = user.id
    redirect '/'
  else
    # an error occurred, re-render the sign-in form, displaying an error
    @error = "Invalid email or password."
    erb :sign_in
  end
end

delete '/sessions/:id' do
  # sign-out -- invoked via AJAX
  return 401 unless params[:id].to_i == session[:user_id].to_i
  session.clear
  200
end


#----------- USERS -----------

get '/users/new' do
  # render sign-up page
  @user = User.new
  erb :sign_up
end

post '/users' do
  # sign-up
  @user = User.new params[:user]
  if @user.save
    # successfully created new account; set up the session and redirect
    session[:user_id] = @user.id
    redirect '/'
  else
    # an error occurred, re-render the sign-up form, displaying errors
    erb :sign_up
  end
end

# ---------- SKILLS -----------

get '/show_skill' do
  @id = session[:user_id]
  @user = User.find(@id)
  @skills = @user.skills.to_a

  # @user = User.find(session[:user_id])
  erb :show_skill
end

get '/edit_skill/:prof_id' do
  prof_id = params[:prof_id]
  @prof = Proficiency.find(prof_id)
  @user = User.find(Proficiency.find(prof_id).user_id)
  @skill = Skill.find(Proficiency.find(prof_id).skill_id)
  erb :edit_skill
end

post '/update_skill/:prof_id' do
  puts params
  prof_id = params[:prof_id]
  prof = Proficiency.find(prof_id)
  prof.year_exp = params[:year]
  prof.trained = params[:trained]
  prof.save
  redirect to '/'
end

