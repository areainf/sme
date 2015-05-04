ActiveAdmin.register User do
  permit_params :username, :email, :password, :role, :password_confirmation

  index do
    # column :surname
    # column :name
    column :username
    column :email
    column :role
    column :created_at
    column :last_sign_in_at
    column :sign_in_count
    # default_actions
    actions
   end

  # filter :surname

  show do
    attributes_table do
        row(:username)
        # row(:surname)
    end
  end

  form do |f|
    f.inputs I18n.t("active_admin.details_user") do
      # f.input :surname
      # f.input :name
      f.input :username
      f.input :email
      f.input :role, :as => :select, :collection => ['admin', 'reception', 'dependency']

      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
      super
    end
  end

end
