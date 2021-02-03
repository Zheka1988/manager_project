require 'rails_helper'

feature 'User can complete task', %q{
  To complete the task, 
  the user can check the completion mark
} do
  
  given(:user) { create :user }
  given(:other_user) { create :user }
  given(:project) { create :project, author: user }
  given!(:task) { create :task, project: project, author: user }

  context "Authenticate user" do
    scenario "Author can mark the task completed" do
      sign_in user
      visit project_path(project)

      within '.tasks' do
        click_on 'Complete'
        expect(page).to_not have_link 'Complete', href: complete_task_task_path(task)
      end
      expect(page).to have_content "Task completed"
    end

    scenario "Not author can't mark the task comleted" do
      sign_in other_user
      visit project_path(project)
      expect(page).to_not have_content "MyString"
      expect(page).to_not have_content "MyText"
      expect(page).to have_content "The page you were looking for doesn't exist."
    end
  end

  scenario "Unauthenticate user" do
    visit project_path(project)
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
