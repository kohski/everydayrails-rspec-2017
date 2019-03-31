require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe "#index" do
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end

      it "responds successfully" do
        sign_in @user
        get :index
        expect(response).to be_success 
      end

      it "responds successfully" do
        sign_in @user
        get :index
        expect(response).to have_http_status "200"
      end
    end
    context "as a guest" do
      it "returns a 302 response" do
        get :index
        expect(response).to have_http_status "302"
      end

      it "sredirects to the sign-in page" do 
        get :index
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#show" do
    context "as an authorize user" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it "responds successfully" do
        sign_in @user
        get :show, params: {id: @project.id}
        expect(response).to be_success
      end
    end
    context "as a guest user" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end
      it "redirect to the dashboards" do
        sign_in @user
        get :show, params: {id: @project.id}
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#create" do
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end

      context "with valid attributes" do
        it "adds a project" do
          project_params = FactoryBot.attributes_for(:project)
          sign_in @user
          expect {
            post :create, params:{ project: project_params }
          }.to change(@user.projects, :count).by(1)
        end
      end

      context "with invalid attributes" do
        it "does not add a project" do
          project_params = FactoryBot.attributes_for(:project, :invalid)
          sign_in @user
          expect {
            post :create, params: { project: project_params }
          }.to_not change(@user.projects, :count)
        end
      end

    end
    context "redirects to the sign-in page" do
      it "returns 302 response" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to have_http_status "302"
      end

      it "redirects to the sign_in page" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#update" do
    context "as an suthorized user" do
      before do 
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end
      it "updates a project" do 
        project_params = FactoryBot.attributes_for(:project,name: "New Project Name")
        sign_in @user
        put :update, params: { id: @project.id, project: project_params}
        expect(@project.reload.name).to eq "New Project Name"
      end
    end
    context "as an unauthorized user" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project,
          owner: other_user,
          name: "Same Old Name"  
        )
      end

      it "doesn't update the project" do
        project_params = FactoryBot.attributes_for(:project,name: "New name")
        sign_in @user
        put :update, params: { id: @project.id, params: project_params }
        expect(@project.reload.name).to eq "Same Old Name"
      end
    
      it "redorects to the dashboard" do
        project_params = FactoryBot.attributes_for(:project)
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to root_path
      end
    end
    context "as a guest" do
      before do
        @project = FactoryBot.create(:project)
      end
    
      it "returns a 302 response" do
        project_params = FactoryBot.attributes_for(:project)
        put :update,params: {id: @project.id, project: project_params}
        expect(response).to have_http_status "302"
      end
    
      it "redirects to sign-in page" do
        project_params = FactoryBot.attributes_for(:project)
        put :update,params: {id: @project.id, project: project_params}
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
  describe "#destroy" do
    context "as an authorized user" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it "deletes a project" do
        sign_in @user
        expect {
          delete :destroy, params: { id: @project.id }
        }.to change(@user.projects, :count).by(-1)
      end
    end
    context "as an unauthorized user" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      it "doesn't delete the project" do
        sign_in @user
        expect {
          delete :destroy, params: { id:@project.id }
        }.to_not change(Project, :count)
      end

      it "redirects to the dash board" do 
        sign_in @user
        delete :destroy, params: { id:@project.id }
        expect(response).to redirect_to root_path
      end
    end
    context "as an guest" do 
      before do
        @project = FactoryBot.create(:project)
      end
      
      it "returns a 302 status " do
        delete :destroy, params:{ id: @project.id }
        expect(response).to have_http_status "302"
      end
      
      it "redirect to sign in page" do
        delete :destroy, params: { id: @project.id }
        expect(response).to redirect_to "/users/sign_in"
      end

      it "does not delete a project" do
        expect {
          delete :destroy, params: { id: @project.id }
        }.to_not change(Project, :count)

      end
      
    end
  end
end