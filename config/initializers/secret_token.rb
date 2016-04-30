# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
if Rails.env.development? or Rails.env.test?
  QueueTip::Application.config.secret_token = ('x' * 30) # meets minimum requirement of 30 chars long
else
  # Require the user to set secret token.  It *must* be unique for
  # every deployment of queue-tip.
  if ENV['SECRET_TOKEN']
    QueueTip::Application.config.secret_token = ENV['SECRET_TOKEN']
  else
    raise "You must provide SECRET_TOKEN in the environment!"
  end
end
