ssh_config = {
  user: 'deploy',
  keys: %w(/Users/noto/.ssh/id_rsa),
  forward_agent: true,
  auth_methods: %w(publickey password),
  port: 4894
}

ec2_role :app,
         ssh_options: ssh_config

ec2_role :db,
         ssh_options: ssh_config

ec2_role :app,
         ssh_options: ssh_config

set :rails_env, :production

