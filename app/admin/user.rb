ActiveAdmin.register User do
  config.filters = false # Disable Ransack filters for User

  # Permit parameters for mass assignment
  permit_params :email, :name, :role

  # Restrict actions to index, show, and update only
  actions :index, :show, :edit, :update
  
  index do
    selectable_column
    id_column
    column :email
    column :name
    column :role
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :email
      row :name
      row :role
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :name
      f.input :role, as: :select, collection: User.roles.keys
    end
    f.actions
  end
end
