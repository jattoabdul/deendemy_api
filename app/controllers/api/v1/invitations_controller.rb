class Api::V1::InvitationsController < Devise::InvitationsController
  include Api::V1::InvitableMethods
  before_action :authenticate_api_v1_user!, only: :create
  before_action :resource_from_invitation_token, only: [:edit, :update]

  def create
    if current_api_v1_user.roles.include?('admin')
      User.invite!(invite_params, current_api_v1_user)
      # TODO: Notify admin about his successful creation of staff user(admin/support)
      render json: { success: ['User Created Successfully.'] }, status: :created
    else
        render json: {
          error: { code: 'Forbidden', message: 'Unauthorized to complete that action.' }
        }, status: 403
    end
  end

  def edit
    # TODO: set client_url and pass as => #{client_api_url}
    redirect_to "https://jatto.tech?invitation_token=#{params[:invitation_token]}"
  end

  def update
    user = User.accept_invitation!(accept_invitation_params)
    if @user.errors.empty?
      # TODO: Notify staff user with welcome notif in-app and send welcome email with login link
      render json: { success: ['User  Invitation Accepted.'] }, status: :accepted
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def invite_params
    params.require(:user).permit(:email, :invitation_token, :provider, :skip_invitation, :first_name, :last_name, :country, :zip, :state, :city, :street, roles: %i())
  end

  def accept_invitation_params
    params.permit(:password, :password_confirmation, :invitation_token)
  end
end
