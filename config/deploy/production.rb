server '52.28.63.85', user: 'deploy', roles: %w{app db web}, primary: true

role :app, %w{deploy@52.28.63.85}
role :web, %w{deploy@52.28.63.85}
role :db,  %w{deploy@52.28.63.85}

set :rails_env, :production

set :ssh_options, {
  keys: %w(/Users/noto/.ssh/id_rsa),
  forward_agent: true,
  auth_methods: %w(publickey password),
  port: 4894
}