require 'rails_helper'

RSpec.describe "Users::Tasks", type: :request do
  fixtures :users, :tasks
  before do
    @user = users(:user1)
    @jwt = authenticate_as_user(@user, "atestpassword")
    @user2_jwt = authenticate_as_user(users(:user2), "atestpassword")
  end
  describe "POST /users/:user_id/tasks" do
    it "creates a new task for this user if the user is authenticated with a jwt" do
      post("/users/#{@user.id}/tasks",
        headers: {
          token: @jwt
        },
        params: {
          task: {
            title: "a new task",
            notes: "this will be a really great task",
          }
        })
      expect(response.status).to eq(200)
      expect(@user.tasks.last.title).to eq("a new task")
    end

    it "Does not create the task if the user is not authenticated" do
      post("/users/#{@user.id}/tasks", params: {
        task: {
          name: "a fresh task",
          notes: "this is a good one",
        }
      })
      expect(response.status).to eq(401)
      expect(Task&.last&.title).to_not eq("a fresh task")
    end
  end

  describe "PUT /users/:user_id/tasks/:id" do
    it "updates the task if the user is authenticated with a jwt" do
      @task = tasks(:task1)
      put("/users/#{@user.id}/tasks/#{@task.id}",
        headers: {
          token: @jwt
        },
        params: {
          task: {
            title: "a stale task"
          }
        })
      expect(response.status).to eq(200)
      @task.reload
      expect(@task.title).to eq("a stale task")
    end

    it "does not update the record if user is authenticated but incorrect" do
      @task = tasks(:task1)
      put("/users/#{@user.id}/tasks/#{@task.id}",
        headers: { token: @user_2_jwt },
        params: {
          task: {
            title: "a stale task"
          }
        })
      expect(response.status).to eq(401)
    end
  end

  describe "DELETE /users/:user_id/tasks/:id" do
    it "deletes the task if user is authenticated and correct" do
      @task = tasks(:task1)
      delete("/users/#{@user.id}/tasks/#{@task.id}", headers: {
        token: @jwt
      })
      expect(response.status).to eq(200)
      expect(@user.tasks.find_by_id(@task.id)).to eq(nil)
    end

    it "does not delete the task if user is authenticated but incorrect" do
      @task = tasks(:task1)
      delete("/users/#{@user.id}/tasks/#{@task.id}", headers: {
        token: @user2_jwt
      })
      expect(response.status).to eq(401)
      expect(@user.tasks.find_by_id(@task.id)).to eq(@task)
    end
  end

  describe "GET /users/:user_id/tasks" do
    it "displays the users tasks if the user is authenticated and correct" do
      get("/users/#{@user.id}/tasks", headers: { token: @jwt })
      expect(response.status).to eq(200)
      parsed_body = JSON.parse(response.body)
      expect(response.body).to eq(@user.tasks.to_json)
    end

    it "does not display the tasks if user is authenticated but incorrect" do
      get("/users/#{@user.id}/tasks", headers: { token: @user2_jwt })
      expect(response.status).to eq(401)
    end
  end

  describe "GET /users/:user_id/task?completed=true" do
    it "displays the users completed tasks" do
      get("/users/#{@user.id}/tasks?completed=true", headers: { token: @jwt })
      expect(response.status).to eq(200)
      parsed_body = JSON.parse(response.body)
      expect(response.body).to eq(@user.tasks.completed.to_json)
    end
  end

  describe "GET /users/:user_id/task?completed=false" do
    it "displays the users incomplete tasks" do
      get("/users/#{@user.id}/tasks?completed=false", headers: { token: @jwt })
      expect(response.status).to eq(200)
      parsed_body = JSON.parse(response.body)
      expect(response.body).to eq(@user.tasks.incomplete.to_json)
    end
  end
end
