require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create :user }
  let(:project) { create :project, author: user }
  let(:task) { create(:task, project: project, author: user) }

  let(:other_user) { create :user }
  let(:other_project) { create :project, author: other_user }    
  let(:other_task) { create(:task, project: other_project, author: other_user) }

  before { login(user) }  
  
  describe 'GET #show' do    
    context "as author" do
      before { get :show, params: { id: task } }
      it "assign the requested task to @task" do
        expect(assigns(:task)).to eq task
      end

      it 'render show view' do
        expect(response).to render_template :show
      end
    end

    context "as not author" do
      before { get :show, params: { id: other_task } }
      
      it "does not assign the requested task to @task" do
        expect(assigns(:task)).to eq nil
      end

      it 'renders page 404 erros' do
        expect(response).to have_http_status(:missing)
      end      
    end
  end

  describe 'GET #new' do
    before { get :new , params: {project_id: project }}
    
    it "assigns new task to @task" do
      expect(assigns(:task)).to be_a_new(Task)
    end

    it "render new view" do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    context "As author" do
      before { get :edit, params: {id: task} }   
      
      it "assigns the requested task to @task" do
        expect(assigns(:task)).to eq task
      end

      it 'render edit view' do
        expect(response).to render_template :edit
      end
    end

    context "As not author" do
      before { get :edit, params: {id: other_task} }
      
      it "does not assign the requested task to @task" do
        expect(assigns(:task)).to eq nil
      end

      it "render page 404 error" do
        expect(response).to have_http_status(:missing)
      end
    end
  end

  describe 'POST #create' do
    context "with valid attribute" do
      it 'communication with logged in user is established' do
        post :create, params: { project_id: project, task: attributes_for(:task) }
        expect(assigns(:task).author_id).to eq(user.id)
      end
      
      it 'saves a new task in the database' do
        expect { post :create, params: {project_id: project, task: attributes_for(:task), author: user } }.to change(Task, :count).by(1)
      end
      
      it 'saves new task related project' do
        expect { post :create, params: {project_id: project, task: attributes_for(:task), author: user } }.to change(project.tasks, :count).by(1)
      end
      
      it 'redirect to show view' do
        post :create, params: {project_id: project, task: attributes_for(:task), author: user }
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
    context "as author" do
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

      context 'with invalid attribute' do
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

    context "as not author" do
      it "does not assign the requested task to @task" do
        patch :update, params: { id: other_task, task: { body: "New body"} }
        expect(assigns(:task)).to eq nil
      end

      it "render page 404 error" do
        patch :update, params: { id: other_task, task: attributes_for(:task) }
        expect(response).to have_http_status(:missing)
      end
    end
  end

  describe 'DELETE #destroy' do    
    context "as author" do
      let!(:task) { create :task, project: project, author: user}      
      it 'deletes the task' do
        expect{ delete :destroy, params: { id: task } }.to change(project.tasks, :count).by(-1)
      end
      
      it 'redirect to index' do
        delete :destroy, params: { id: task }
        expect(response).to redirect_to project_path(project)
      end
    end

    context "as not author" do
      let!(:other_task) { create :task, project: other_project, author: other_user}
      it "not delete the task" do
        expect { delete :destroy, params: { id: other_task } }.to_not change(other_project.tasks, :count)
      end

      it "render page 404 error" do
        delete :destroy, params: { id: other_task }
        expect(response).to have_http_status :missing
      end
    end
  end

  describe 'POST #complete_task' do
    context "Author" do
      it 'can complete task' do
        post :complete_task, params: { id: task, task: { completed: :true } }
        task.reload
        expect(task.completed).to eq true
      end

      it "redirect_to show @task.project" do
        post :complete_task, params: { id: task, task: { completed: :true } }
        expect(response).to redirect_to assigns(:task).project 
      end
    end
    context "as not author" do
      it 'can not complete task' do
        post :complete_task, params: { id: other_task, task: { completed: :true } }
        other_task.reload
        expect(other_task.completed).to eq false
      end

      it "render page 404 error" do
        post :complete_task, params: { id: other_task, task: { completed: :true } }
        expect(response).to have_http_status :missing 
      end
    end    
  end

end
