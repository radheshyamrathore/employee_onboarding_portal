# app/controllers/tasks_controller.rb
class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_employee
  load_and_authorize_resource

  def new
    byebug
    @task = @employee.tasks.build
  end

  def create
    @task = @employee.tasks.build(task_params)
    if @task.save
      redirect_to @employee, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def edit
    @task = @employee.tasks.find(params[:id])
  end

  def update
    @task = @employee.tasks.find(params[:id])
    if @task.update(task_params)
      redirect_to employee_path(@employee), notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_employee
    byebug
    @employee = Employee.find(params[:employee_id])
  end

  def task_params
    params.permit(:title, :description, :status, :employee_id)
  end
end
