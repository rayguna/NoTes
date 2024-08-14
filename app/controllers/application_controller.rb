class ApplicationController < ActionController::Base
  helper MarkdownHelper
  include MarkdownHelper # Include the module to make it available in controllers
  include BreadcrumbsHelper

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_devise_resource
  before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  def render_markdown(text)
    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer, extensions = {})
    markdown.render(text).html_safe
  end

  private

  def set_devise_resource
    if !user_signed_in?
      @resource = User.new
      @resource_name = :user
      @devise_mapping = Devise.mappings[:user]
    end
  end
end
