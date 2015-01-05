def set_current_user(user = nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def sign_in(user=nil)
  alice = (user || Fabricate(:user))
  visit('/sessions/new')
  fill_in('Email Address', :with =>  alice.email )
  fill_in('Password', :with => alice.password)
  click_button 'Sign in'
end

def click_on_video_on_homepage(video)
  find("a[href='/videos/#{video.id}']").click
end

def sign_out
	visit logout_path
end