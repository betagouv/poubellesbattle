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
    policy.frame_src   'https://compostable-ou-non.now.sh/', 'https://www.google.com/recaptcha/api2/anchor?ar=1&k=6Lfo494ZAAAAAHaP_12mgK1Pk2VuE7BNGp9NPkga&co=aHR0cDovL2xvY2FsaG9zdDozMDAw&hl=en&v=4lbq4vBYAu25DMtzZ7GGbfAF&size=normal&cb=4k88bmbch2v7'
    policy.style_src   :self, :unsafe_inline, 'fonts.googleapis.com', '*.bootstrapcdn.com', '*.mapbox.com', '*.mailchimp.com', '*.crisp.chat:*', '*.client.crisp.chat:*'
    if Rails.env.development?
      policy.script_src  :self, :unsafe_eval, 'http://localhost:3000', 'stats.data.gouv.fr', '*.mapbox.com', '*.crisp.chat:*', '*.client.crisp.chat:*', 'https://stats.data.gouv.fr/piwik.js', 'https://www.recaptcha.net/recaptcha/api.js', 'https://www.gstatic.com/recaptcha/releases/4lbq4vBYAu25DMtzZ7GGbfAF/recaptcha__en.js'
      policy.connect_src :self, :https, 'http://localhost:3035', 'ws://localhost:3035', 'ws://localhost:3000', 'wss://*.crisp.chat', '*.crisp.chat', '*.client.crisp.chat:*', 'https://*.tiles.mapbox.com', 'https://api.mapbox.com', 'https://events.mapbox.com'
    else
      policy.script_src  :self, :unsafe_eval, 'stats.data.gouv.fr', '*.crisp.chat', 'crisp.chat', '*.mapbox.com', 'https://client.crisp.chat/l.js', 'https://stats.data.gouv.fr/piwik.js', 'https://client.crisp.chat/static/javascripts/client.js', 'https://www.recaptcha.net/recaptcha/api.js', 'https://www.gstatic.com/recaptcha/releases/4lbq4vBYAu25DMtzZ7GGbfAF/recaptcha__en.js'
      policy.connect_src :self, 'wss://*.crisp.chat', '*.crisp.chat', 'https://*.tiles.mapbox.com', 'https://api.mapbox.com', 'https://events.mapbox.com'
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
