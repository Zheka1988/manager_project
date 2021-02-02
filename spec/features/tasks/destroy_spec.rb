require 'rails_helper'

feature 'User can delete projects',%q{
  Authenticated user can delete project
}do
  given(:user) { create :user }
  given(:project) { create :project }
  given!(:task) { create :task, project: project }

  scenario "Authenticated user tries delete project" do
    sign_in user
    visit project_path(project)
    within '.tasks' do
      click_on 'Delete'
      expect(page).to_not have_content 'MyText'
    end

  end
  
  scenario "Unauthenticated user tries delete project" do
    visit project_path(project)
    within '.tasks' do
      expect(page).to_not have_link 'Delete', href: task_path(task)
    end
  end
end
