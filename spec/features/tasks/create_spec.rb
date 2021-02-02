require 'rails_helper'

feature 'User can add task to project', %q{ 
  In order to break into stages the project,
  user can add task
} do
  given(:user) { create :user }
  given(:project) { create :project }
  
  context "Authenticated user can add task for project" do
    background do
      sign_in user
      visit project_path(project)
      click_on 'Add Task'
    end

    scenario "with valid attribute" do
      fill_in 'Body', with: 'New task'
      select '1', from: 'Priority' 
      select_date 2.days.from_now, from: "task_deadline"
      click_on "Save"

      expect(page).to have_content "Your task has been successfully added."
      expect(page).to have_content "New task"
    end

    scenario "with invalid attribute" do
      click_on "Save"
      expect(page).to have_content "Body can't be blank"
    end
  end
  scenario "Unauthenticated user can add task for project" do
    visit project_path(project)
    click_on 'Add Task'
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
