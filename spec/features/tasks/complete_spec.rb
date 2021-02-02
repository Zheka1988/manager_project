require 'rails_helper'

feature 'User can complete task', %q{
  To complete the task, 
  the user can check the completion mark
} do
  
  given(:user) { create :user }
  given(:project) { create :project, author: user }
  given!(:task) { create :task, project: project, author: user }

  scenario "User can mark the task completed" do
    sign_in user
    visit project_path(project)

    within '.tasks' do
      click_on 'Complete'
      expect(page).to_not have_link 'Complete', href: complete_task_task_path(task)
    end
    expect(page).to have_content "Task completed"
  end
end
