# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_calendar_session',
  :secret      => 'ae8026f005c68d8d9e5e0ed67b8636857c8aaa689b7184d9d9c50f69ca8b91d7e035688ca2041b448e7678cf910ec0b11ccfa651b2bbef6babc91dab1d4b7ccc'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
