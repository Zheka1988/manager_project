# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete tasks', '
  Authenticated user can delete task
' do
  given(:user) { create :user }
  given(:other_user) { create :user }
  given(:project) { create :project, author: user }
  given!(:task) { create :task, project: project, author: user }

  context 'Authenticated user' do
    scenario 'author tries delete task', js: true do
      sign_in user
      visit project_path(project)
      within '.tasks' do
        # find("a[href='#{task_path(task)}']").click
        click_on(class: 'delete-task-link')
        expect(page).to_not have_css "#task-#{task.id}"
      end
    end
    scenario 'not author tries delete task' do
      sign_in other_user
      visit project_path(project)
      expect(page).to_not have_content 'MyString'
      expect(page).to_not have_content 'MyText'
      expect(page).to have_content "The page you were looking for doesn't exist."
    end
  end

  scenario 'Unauthenticated user tries delete task' do
    visit project_path(project)
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
