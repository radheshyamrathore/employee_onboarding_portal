# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def linkedin
    # You can also use this for Google if you've set up Google login similarly
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      # Ensure the user has an OTP secret for 2FA
      @user.otp_secret ||= User.generate_otp_secret
      @user.save

      session[:otp_user_id] = @user.id
      sign_in_and_redirect @user, event: :authentication # This will log the user in
    else
      session['devise.linkedin_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2
    user = User.from_google(from_google_params)

    if user.present?
      sign_out_all_scopes
      flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect user, event: :authentication
    else
      flash[:alert] = t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
      redirect_to new_user_session_path
    end
  end

  protected

  def after_omniauth_failure_path_for(_scope)
    new_user_session_path
  end

  private

  def from_google_params
    @from_google_params ||= {
      uid: auth.uid,
      email: auth.info.email,
      full_name: auth.info.name,
      avatar_url: auth.info.image,
      provider: 'google_oauth2'
    }
  end

  def auth
    @auth ||= request.env['omniauth.auth']
  end
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
