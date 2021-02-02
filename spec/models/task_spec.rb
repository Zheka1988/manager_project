require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should belong_to :project}
  it { should validate_presence_of :body }

  context "complete task" do
    let(:user) { create :user }
    let(:project) { create :project, author: user }
    let!(:task) { create :task, project: project, author: user }

    it 'completed task' do
      task.complete_task
      expect(task).to be_completed
    end
  end

end
