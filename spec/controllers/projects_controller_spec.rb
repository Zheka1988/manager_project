require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create :project, author: user }
  
  before { login(user) }  

  describe 'GET #index' do
    let(:projects) { create_list(:project, 3, author: user) }
    before { get :index}      
    it 'populates an array of all projects' do
      expect(assigns(:projects)).to match_array(projects)
    end
    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do  
    before { get :show, params: {id: project } }

    it 'assigns the requested project to @project' do
      expect(assigns(:project)).to eq project
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do 
    before { get :new }

    it 'assigns a new Project to @project' do
      expect(assigns(:project)).to be_a_new(Project)
    end
    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do 
    before { get :edit, params: {id: project } }

    it 'assigns the requested project to @project' do
      expect(assigns(:project)).to eq project
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'communication with logged in user is established' do
        post :create, params: { project: attributes_for(:project) }
        expect(assigns(:project).author_id).to eq user.id
      end

      it 'saves a new project in the database' do
        expect { post :create, params: { project: attributes_for(:project), author: user } }.to change(Project, :count).by(1)
      end
      it 'redirect to show view' do
        post :create, params: { project: attributes_for(:project, author: user) }
        expect(response).to redirect_to assigns(:project)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the project in database' do
        expect { post :create, params: { project: attributes_for(:project, :invalid) } }.to_not change(Project, :count)
      end
      it 're-renders new view' do
        post :create, params: { project: attributes_for(:project, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'assigns the requested project to @project' do
        patch :update, params: { id: project, project: attributes_for(:project) }
        expect(assigns(:project)).to eq project
      end

      it 'changes projects attributes' do
        patch :update, params: { id: project, project: { title: 'new title', description: 'new description' } }
        project.reload

        expect(project.title).to eq "new title"
        expect(project.description).to eq "new description"
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

        expect(project.title).to eq "MyString"
        expect(project.description).to eq "MyString"
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end    
  end

  describe 'DELETE #destroy' do
    let!(:project) { create(:project, author: user) }

    it 'deletes the project' do
      expect { delete :destroy, params: { id: project } }.to change(Project, :count).by(-1)      
    end
    
    it 'redirects to index' do
      delete :destroy, params: {id: project}
      expect(response).to redirect_to projects_path
    end
  end


end
