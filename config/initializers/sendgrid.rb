# config/initializers/sendgrid.rb
ActionMailer::Base.smtp_settings = {
    :user_name => '',
    :password => '',
    :domain => 'imageutil.io',
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
  }