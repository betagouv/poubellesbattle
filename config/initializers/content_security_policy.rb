# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy
unless Rails.env.test?

  Rails.application.config.content_security_policy do |policy|
    policy.default_src :self
    policy.font_src    :self, :data, 'fonts.gstatic.com', 'bootstrapcdn.com', 'maxcdn.bootstrapcdn.com', 'crisp.chat', 'client.crisp.chat'
    policy.img_src     :self, :data, :blob, 'cloudinary.com', 'openstreetmap.org', 'stats.data.gouv.fr', 'crisp.chat', 'https://image.crisp.chat/', 'https://client.crisp.chat/', 'res.cloudinary.com'
    policy.worker_src  :self, :blob
    policy.object_src  :none
    policy.frame_src   'https://compostable-ou-non.now.sh/', 'https://stats.data.gouv.fr/index.php?module=CoreAdminHome&action=optOut'
    policy.style_src   :self, :unsafe_inline, 'fonts.googleapis.com', 'maxcdn.bootstrapcdn.com/', 'bootstrapcdn.com', 'mapbox.com', 'mailchimp.com','cdn-images.mailchimp.com', 'crisp.chat', 'client.crisp.chat'
    if Rails.env.development?
      policy.script_src  :self, 'http://localhost:3000', 'stats.data.gouv.fr', 'mapbox.com', 'crisp.chat', 'client.crisp.chat', 'https://stats.data.gouv.fr/piwik.js', 'https://settings.crisp.chat', 'https://client.crisp.chat/'
      policy.connect_src :self, :https, 'http://localhost:3035', 'ws://localhost:3035', 'ws://localhost:3000', 'wss://crisp.chat', 'wss://client.relay.crisp.chat', 'crisp.chat', 'client.crisp.chat', 'https://tiles.mapbox.com', 'https://api.mapbox.com', 'https://events.mapbox.com'
    else
      policy.script_src  :self, 'stats.data.gouv.fr', 'crisp.chat', 'mapbox.com', 'https://client.crisp.chat/', 'https://settings.crisp.chat', 'https://stats.data.gouv.fr/piwik.js', 'https://client.crisp.chat/static/javascripts/'
      policy.connect_src :self, 'wss://crisp.chat', 'wss://client.relay.crisp.chat', 'crisp.chat', 'https://tiles.mapbox.com', 'https://api.mapbox.com', 'https://events.mapbox.com'
    end
    # Specify URI for violation reports
    # policy.report_uri "/csp-violation-report-endpoint"
  end

end

# If you are using UJS then enable automatic nonce generation
Rails.application.config.content_security_policy_nonce_generator = -> request { SecureRandom.base64(16) }

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true
