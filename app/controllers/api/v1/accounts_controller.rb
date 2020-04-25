class Api::V1::AccountsController < Api::V1::ApplicationController
  include ErrorSerializer
  before_action :set_user, only: [:assign_roles, :unassign_roles]

  ALLOWED_ROLES = ['admin', 'support', 'tutor', 'learner'].freeze

  # TODO: update user serializer fields

  # POST accounts/{user_id}/roles/assign
  def assign_roles
    role = user_roles_params[:role]
    bad_request_error('Role is not allowed') && return unless ALLOWED_ROLES.include?(role)
    bad_request_error('Role already exists for user') && return if @user.roles.include?(role)

    @user.roles << role
    @user.save!

    render json: @user, status: :accepted
  end

  # POST accounts/{user_id}/roles/unassign
  def unassign_roles
    role = user_roles_params[:role]
    bad_request_error('Role is not allowed') && return unless ALLOWED_ROLES.include?(role)
    bad_request_error('User must have atleast one Role') && return if @user.roles.length <= 1
    bad_request_error('Role does not exists for User') && return unless @user.roles.include?(role)

    @user.roles.delete(role)
    @user.save!

    render json: @user, status: :accepted
  end

  # GET /accounts
  def index
    filter = params[:filter] || nil # filters for read/unread

    @users = if filter == 'staff'
    User.staff
    elsif filter == 'tutor'
    User.tutors
    elsif filter == 'learner'
    User.learners
    else
    User.all
    end

    render json: @users
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_roles_params
    params.require(:role)
    params.permit(:role)
  end

  def user_params
    params.permit(:email, :password, :password_confirmation, :first_name, :last_name, :country, :zip, :state, :city, :street, roles: %i())
  end
end
