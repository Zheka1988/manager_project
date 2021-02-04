# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create :project, author: user }

  let(:other_user) { create :user }
  let(:other_project) { create :project, author: other_user }

  before { login(user) }

  describe 'GET #index' do
    let(:projects) { create_list(:project, 3, author: user) }
    before { get :index }

    it 'array of all projects have author is current_user' do
      expect(assigns(:projects)).to eq user.authored_projects
    end

    it 'populates an array of all projects' do
      expect(assigns(:projects)).to match_array(projects)
    end

    it 'assigns a new Project to @project' do
      expect(assigns(:project)).to be_a_new(Project)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    context 'as author' do
      before { get :show, params: { id: project } }
      it 'assigns the requested project to @project' do
        expect(assigns(:project)).to eq project
      end

      it 'renders show view' do
        expect(response).to render_template :show
      end

      it 'assigns new task to @task' do
        expect(assigns(:task)).to be_a_new(Task)
      end
    end

    context 'as not author' do
      before { get :show, params: { id: other_project } }

      it 'does not assign the requested project to @project' do
        expect(assigns(:project)).to eq nil
      end

      it 'renders page 404 error' do
        expect(response).to have_http_status(:missing)
      end
    end
  end

  describe 'GET #edit' do
    context 'as author' do
      before { get :edit, params: { id: project } }

      it 'assigns the requested project to @project' do
        expect(assigns(:project)).to eq project
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'as not author' do
      before { get :edit, params: { id: other_project } }

      it 'does not assign the requested project to @project' do
        expect(assigns(:project)).to eq nil
      end

      it 'renders page 404 error' do
        expect(response).to have_http_status(:missing)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'communication with logged in user is established' do
        post :create, params: { project: attributes_for(:project) }
        expect(assigns(:project).author_id).to eq user.id
      end

      it 'saves a new project in the database' do
        expect do
          post :create, params: { project: attributes_for(:project), author: user }
        end.to change(Project, :count).by(1)
      end
      it 'redirect to index view' do
        post :create, params: { project: attributes_for(:project, author: user) }
        expect(response).to redirect_to projects_path
      end
    end

    context 'with invalid attributes' do
      it 'does not save the project in database' do
        expect { post :create, params: { project: attributes_for(:project, :invalid) } }.to_not change(Project, :count)
      end
      it 're-renders new view' do
        post :create, params: { project: attributes_for(:project, :invalid) }
        expect(response).to render_template :index
      end
    end
  end

  describe 'PATCH #update' do
    context 'Author' do
      context 'with valid attributes' do
        it 'assigns the requested project to @project' do
          patch :update, params: { id: project, project: attributes_for(:project) }
          expect(assigns(:project)).to eq project
        end

        it 'changes projects attributes' do
          patch :update, params: { id: project, project: { title: 'new title', description: 'new description' } }
          project.reload

          expect(project.title).to eq 'new title'
          expect(project.description).to eq 'new description'
        end

        it 'redirect to updated project' do
          patch :update, params: { id: project, project: attributes_for(:project) }
          expect(response).to redirect_to project
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: project, project: attributes_for(:project, :invalid) } }
        it 'does not change project' do
          project.reload

          expect(project.title).to eq 'MyString'
          expect(project.description).to eq 'MyString'
        end

        it 're-render edit view' do
          expect(response).to render_template :edit
        end
      end
    end

    context 'Not author' do
      it 'does not assign the requested project to @project' do
        patch :update, params: { id: other_project, project: { title: 'new title', description: 'new description' } }
        expect(assigns(:project)).to eq nil
      end

      it 'renders page 404 error' do
        patch :update, params: { id: other_project, project: attributes_for(:project) }
        expect(response).to have_http_status(:missing)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Author' do
      let!(:project) { create(:project, author: user) }

      it 'deletes the project' do
        expect { delete :destroy, params: { id: project } }.to change(Project, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: project }
        expect(response).to redirect_to projects_path
      end
    end
    context 'Not author' do
      let!(:other_project) { create :project, author: other_user }

      it 'not delete the project' do
        expect { delete :destroy, params: { id: other_project } }.to_not change(Project, :count)
      end
      it 'renders page 404 error' do
        delete :destroy, params: { id: other_project }
        expect(response).to have_http_status(:missing)
      end
    end
  end
end
