# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_linaria_session',
  :secret      => '3ee8d5e34af6c07b4af11cca955a45e87f39923d4892549d525e90fd5a07233edbae74f88c1e3ea5f8f3c90497fec98998f3b6e6ae95e614d846fb10ab6499d3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
