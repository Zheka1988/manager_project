require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:authored_projects).class_name("Project")}
  it { should have_many(:authored_tasks).class_name("Task")}

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'Methods' do
    let(:user) { create :user }
  
    it "valid verification of authorship" do
      project = FactoryBot.create(:project, author: user)
      expect(user).to be_author_of(project)
    end
    it "invalid verification of authorship" do
      other_user = FactoryBot.create(:user)
      project = FactoryBot.create(:project, author: other_user)
      expect( user.author_of?(project) ).to eq false
    end
  end
end
