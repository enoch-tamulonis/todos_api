module Users
  class TasksController < BaseController
    before_action :set_task, only: [:update, :show, :destroy]
    def index
      if params[:completed].present?
        @tasks = @user.tasks.where(completed: params[:completed])
      else
        @tasks = @user.tasks
      end
      render json: @tasks
    end

    def show
      render json: @task
    end

    def create
      @task = @user.tasks.new(task_params)
      if @task.save
        render json: { message: "Task was created successfully", task: @task }
      else
        render json: { errors: @task.errors }, status: :unprocessable_entity
      end
    end

    def update
      if @task.update(task_params)
        render json: { message: "Task was updated successfully" }
      else
        render json: { errors: @task.errors }, status: :unprocessable_entity
      end
    end

    def destroy
      if @task.destroy
        render json: { message: "Task was destroyed successfully" }
      else
        render json: { message: "There was a problem destroying this task" }
      end
    end
  private
    def task_params
      params.require(:task).permit(:title, :completed, :notes)
    end

    def set_task
      begin
        @task = @user.tasks.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { message: "No task was found for that user and id"}, status: :unprocessable_entity
      end
    end
  end
end
