# frozen_string_literal: true

require 'rails_helper'

feature 'User can add task to project', '
  In order to break into stages the project,
  user can add task
' do
  given(:user) { create :user }
  given(:project) { create :project, author: user }

  context 'Authenticated user can add task for project', js: true do
    background do
      sign_in user
      visit project_path(project)
    end

    scenario 'with valid attribute' do
      within 'form.form-new-task' do
        fill_in 'Body', with: 'New task'
        select '1', from: 'Priority'
        select_date 2.days.from_now, from: 'task_deadline'
        click_on 'Save'
      end

      expect(current_path).to eq project_path(project)
      within '.tasks' do
        expect(page).to have_content 'New task'
      end
    end

    scenario 'with invalid attribute' do
      within 'form.form-new-task' do
        click_on 'Save'
      end
      within '.task-errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end
  end
  scenario 'Unauthenticated user can add task for project' do
    visit project_path(project)

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
