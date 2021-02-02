require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:authored_projects).class_name("Project")}
  it { should have_many(:authored_tasks).class_name("Task")}

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
end
