require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should belong_to :project}
  it { should validate_presence_of :body }
end
