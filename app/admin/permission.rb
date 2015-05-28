ActiveAdmin.register Permission do
  permit_params :user_id, :personal_documents, :dependencies => [], :employments => []

  index do
    column :user do | u |
      u.user.username
    end
    column :dependency_names
    column :employment_names
    column :personal_documents
    # default_actions
    actions
   end

  show do
    attributes_table do
      row(:user)
      row(:dependency_names)
      row(:employment_names)
      row(:personal_documents) do | value |
        I18n.t("boolean.#{value.personal_documents}_value")
      end
    end
  end

  form do |f|
    f.inputs I18n.t("active_admin.pemissions") do
      if f.object.new_record?
        f.input :user_id, :as => :select, :collection => options_from_collection_for_select(User.dependency_without_persmission, 'id', 'username')
      else
        f.input :user_id, :input_html =>{value: f.object.user.username, disabled: 'disabled', type: 'text'}
      end  
      f.input :dependencies, :as => :select, :collection => options_from_collection_for_select(Dependency.all, 'id', 'name', f.object.dependencies), :multiple => true
      f.input :employments, :as => :select, :collection => options_from_collection_for_select(Employment.all, 'id', 'name', f.object.employments), :multiple => true
      f.input :personal_documents
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit permission: [:user_id, :personal_documents, :dependencies => [], :employments => []]
    end
  end
end

