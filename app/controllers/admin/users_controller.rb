module Admin
  class UsersController < Admin::ApplicationController
    before_action :remove_password_params_if_blank, :update_role, only: [:update]

    # Overwrite any of the RESTful controller actions to implement custom behavior
    # For example, you may want to send an email after a foo is updated.
    #
    # def update
    #   super
    #   send_foo_updated_email(requested_resource)
    # end

    def remove_password_params_if_blank
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
    end

    def update_role
      @user = User.where(email: params[:user][:email]).first
      @user.roles = [] # Clears all User roles
      params[:user][:roles].each do |role|
        if (role.empty? != false) == false
          @updated_role = Role.find(role.to_i)
          # if ((@user.has_role? @updated_role.name.to_sym) == false)
          #   @user.add_role @updated_role.name.to_sym
          # end
          @user.add_role @updated_role.name.to_sym if ((@user.has_role? @updated_role.name.to_sym) == false)
        end
      end
    end


    # Override this method to specify custom lookup behavior.
    # This will be used to set the resource for the `show`, `edit`, and `update`
    # actions.
    #
    # def find_resource(param)
    #   Foo.find_by!(slug: param)
    # end

    # The result of this lookup will be available as `requested_resource`

    # Override this if you have certain roles that require a subset
    # this will be used to set the records shown on the `index` action.
    #
    # def scoped_resource
    #   if current_user.super_admin?
    #     resource_class
    #   else
    #     resource_class.with_less_stuff
    #   end
    # end

    # Override `resource_params` if you want to transform the submitted
    # data before it's persisted. For example, the following would turn all
    # empty values into nil values. It uses other APIs such as `resource_class`
    # and `dashboard`:
    #
    # def resource_params
    #   params.require(resource_class.model_name.param_key).
    #     permit(dashboard.permitted_attributes).
    #     transform_values { |value| value == "" ? nil : value }
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
