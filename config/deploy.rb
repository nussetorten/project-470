require 'bundler/capistrano'
require 'rvm/capistrano'

set :application, "roomie"
set :deploy_to, "/home/ubuntu/#{application}"

set :user, 'ubuntu'
set :use_sudo, false
ssh_options[:keys] = [File.join('~/.ssh/amazon_ec2_project_2.pem')] # Key for Everett's ec2 instance

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :scm, :git
set :repository, 'git@github.com:everett1992/project-470'
set :branch, 'aws-deploy'
set :deploy_via, :remote_cache

ssh_options[:forward_agent] = true

server '54.235.87.183', # Everett's ec2 server
 	:app,
 	:web,
 	:db,
 	:primary => true

# if you want to clean up old releases on each deploy uncomment this:
set :keep_releases, 2
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after 'deploy:update_code', 'deploy:migrate'
