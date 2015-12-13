OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1249381345077488', 'cbe7775310eb68df3f2d4a85aa71119f'
end
