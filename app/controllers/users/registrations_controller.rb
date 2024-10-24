# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.persisted?
        resource.otp_secret = User.generate_otp_secret
        resource.save
        session[:otp_user_id] = resource.id
        redirect_to users_two_factor_setup_path
      end
    end
  end

  def two_factor_setup
    @user = User.find(session[:otp_user_id])
    @otp_secret = @user.otp_secret
    @qr_code = RQRCode::QRCode.new(
      @user.provisioning_uri(
        @user.email,
        issuer: 'Your App Name'
      )
    ).as_svg(module_size: 4).html_safe
  end
  
  def update
    super do |resource|
      if params[:user][:otp_attempt].present?
        if resource.validate_and_consume_otp!(params[:user][:otp_attempt])
          resource.otp_required_for_login = true
          resource.save
          set_flash_message :notice, :two_factor_enabled
        else
          set_flash_message :alert, :two_factor_incorrect
          render :two_factor_setup and return
        end
      end
    end
  end
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
