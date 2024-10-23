# app/controllers/dashboards_controller.rb
class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def redirect_based_on_role
    if current_user.role == 'hr_manager'
      redirect_to hr_manager_dashboard_path
    elsif current_user.role == 'employee'
      redirect_to employee_dashboard_path
    else
      redirect_to root_path, alert: "Unauthorized access"
    end
  end

  def employee
    if current_user.role == 'employee'
      @employee = current_user.employee
      @tasks = @employee&.tasks
    elsif current_user.role == 'hr_manager'
      @employee = Employee.find_by(id: params[:employee_id])
      @tasks = @employee&.tasks if @employee
    else
      redirect_to root_path, alert: "Unauthorized access"
    end
  end

  def hr_manager
    if current_user.role == "hr_manager"
      @employees = Employee.all
    end
  end
end