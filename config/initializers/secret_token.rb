# Be sure to restart your server when you modify this file.

# Your secret base key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random, no
# regular words or you'll be exposed to dictionary attacks.
if Rails.env.development? or Rails.env.test?
  QueueTip::Application.config.secret_key_base = ('x' * 30) # meets minimum requirement of 30 chars long
else
  # Require the user to set secret token base key.  It *must* be
  # unique for every deployment of queue-tip.
  if ENV['SECRET_KEY_BASE']
    QueueTip::Application.config.secret_key_base = ENV['SECRET_KEY_BASE']
  else
    raise "You must provide SECRET_KEY_BASE in the environment!"
  end
end
