lock '3.4.0'

set :ec2_config, 'config/ec2.yml'
set :log_level, :debug
set :application, 'flashcards'
set :branch, ENV['BRANCH_NAME'] || 'master'
set :repo_url, 'git@github.com:isnoto/flashcards.git'
set :deploy_to, '/home/deploy/flashcards'
set :linked_files, fetch(:linked_files, []).push('config/database.yml', '.env')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  desc 'Runs rake db:seed'
  task seed: [:set_rails_env] do
    on primary fetch(:migration_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:seed'
        end
      end
    end
  end
end
