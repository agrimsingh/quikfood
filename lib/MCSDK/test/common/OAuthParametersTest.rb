require '../OAuthParameters'

params = OAuthParameters.new('hello')
puts(params.consumer_key)
puts(params.nonce)
puts(params.timestamp)
puts(params.oauth_version)
puts(params.signature_method)

#hashed body
puts(params.generate_body_hash('foo'))
puts(params.generate_body_hash('bar'))
#blank line
puts(params.generate_body_hash(nil))