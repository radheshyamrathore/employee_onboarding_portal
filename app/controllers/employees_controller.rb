# app/controllers/employees_controller.rb
class EmployeesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:new, :edit]
    load_and_authorize_resource
  
    def index
      @employees = Employee.all
    end
  
    def show
    end
  
    def new
      @employee = Employee.new
    end
  
    def create
      @employee = Employee.new(employee_params)
      if @employee.save
        redirect_to @employee, notice: 'Employee was successfully created.'
      else
        render :new
      end
    end    
  
    def edit
    end
  
    def update
      if @employee.update(employee_params)
        redirect_to @employee, notice: 'Employee was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      byebug
      @employee.destroy
      redirect_to employees_url, notice: 'Employee was successfully deleted.'
    end
  
    private

    def set_user
      @available_users = User.where(role: :employee).left_outer_joins(:employee).where(employees: { id: nil })
    end
  
    def employee_params
      params.require(:employee).permit(:name, :email, :department, :role, :onboarding_status, :user_id)
    end
  end