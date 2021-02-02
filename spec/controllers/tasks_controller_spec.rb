require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create :user }
  let(:project) { create :project }
  let(:task) { create(:task, project: project) }

  describe 'GET #show' do
    before { login(user) }  
    before { get :show, params: { id: task } }
    it "assign the requested task to @task" do
      expect(assigns(:task)).to eq task
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }  
    before { get :new , params: {project_id: project }}
    it "assigns new task to @task" do
      expect(assigns(:task)).to be_a_new(Task)
    end

    it "render new view" do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }  
    before { get :edit, params: {id: task} }   
    it "assigns the requested task to @task" do
      expect(assigns(:task)).to eq task
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }  
    context "with valid attribute" do
      it 'saves a new task in the database' do
        expect { post :create, params: {project_id: project, task: attributes_for(:task) } }.to change(Task, :count).by(1)
      end
      it 'saves new task related project' do
        expect { post :create, params: {project_id: project, task: attributes_for(:task) } }.to change(project.tasks, :count).by(1)
      end
      it 'redirect to show view' do
        post :create, params: {project_id: project, task: attributes_for(:task) }
        expect(response).to redirect_to assigns(:task)
      end
    end

    context "with invalid attribute" do
      it 'does not save the project in database' do
        expect { post :create, params: {project_id: project, task: attributes_for(:task, :invalid) } }.to_not change(Task, :count)
      end
      it 're-renders new view' do
        post :create, params: {project_id: project, task: attributes_for(:task, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }  
    context 'with valid attribute' do
      it 'assigns the requested task to @task' do
        patch :update, params: { id: task, task: attributes_for(:task) }
        expect(assigns(:task)).to eq task
      end
      it 'changes task attributes' do
        patch :update, params: { id: task, task: { body: "New body"} }
        expect(assigns(:task).body).to eq "New body"
      end
      it 'redirect to updated task' do
        patch :update, params: { id: task, task: attributes_for(:task) }
        expect(response).to redirect_to task
      end
    end
    context 'with valid attribute' do
      before { patch :update, params: { id: task, task: attributes_for(:task, :invalid) } }
      it 'not changes task attributes' do
        task.reload
        expect(task.body).to eq "MyText"
      end
      it "render edit view" do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }  
    let!(:task) { create :task, project: project}
    it 'deletes the task' do
      expect{ delete :destroy, params: { id: task } }.to change(project.tasks, :count).by(-1)
    end
    it 'redirect to index' do
      delete :destroy, params: { id: task }
      expect(response).to redirect_to project_path(project)
    end

  end
end
