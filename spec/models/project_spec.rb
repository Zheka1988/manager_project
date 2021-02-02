require 'rails_helper'

RSpec.describe Project, type: :model do
  it { should have_many(:tasks).dependent(:destroy) }
  it { should belong_to(:author).class_name('User') }

  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_most(200) }
  it { should validate_presence_of(:description) }
  it { should validate_length_of(:description).is_at_most(200) }
end
