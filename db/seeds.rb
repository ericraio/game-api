puts 'EMPTY THE MONGODB DATABASE'
Mongoid.master.collections.reject { |c| c.name =~ /^system/}.each(&:drop)
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'user1', :email => 'user@example.com', :password => 'please123123', :password_confirmation => 'please123123'
puts 'New user created: ' << user.name
user2 = User.create! :name => 'user2', :email => 'user2@example.com', :password => 'please123123', :password_confirmation => 'please123123'
puts 'New user created: ' << user2.name
