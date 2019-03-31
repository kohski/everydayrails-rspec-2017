require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project, owner: @user)
    @task = @project.tasks.create!(name: "task test")
  end

  describe "#show" do
    it "responds with JSON formatted output" do
      sign_in @user
      get :show, format: :json,params:{ project_id: @project.id, id: @task.id }
      expect(response.content_type).to eq "application/json"
    end

    it "responds with HTML formatted output" do
      sign_in @user
      get :show,params:{ project_id: @project.id, id: @task.id }
      expect(response.content_type).to eq "text/html"
    end
  end

  describe "#create" do
    it "adds a new task to the project" do
      new_task = { name: "New task test" }
      sign_in @user
      post :create, format: :json, params:{ project_id: @project.id, task: new_task }
      expect(response.content_type).to eq "application/json"
    end

    it "require authentification" do
      new_task = { name: "New test task" }
      expect {
        post :create, format: :json, params:{ project_id: @project.id, task: new_task }
      }.to_not change(@project.tasks, :count)
      expect(response).to_not be_success
    end
  end

end
