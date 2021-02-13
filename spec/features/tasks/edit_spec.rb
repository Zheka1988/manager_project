# frozen_string_literal: true

require 'rails_helper'

feature 'User can edited tasks', '
  In order correct task, user can edited task
' do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:project) { create :project, author: user }
  given!(:task) { create :task, project: project, author: user }

  describe 'Authenticated user ' do
    context 'Author tries', js: true do
      background do
        sign_in(user)
        visit project_path(project)
        within '.tasks' do
          click_on(class: 'edit-task-link')
        end
      end

      scenario 'edited task with valid attributes' do
        within '.tasks' do
          fill_in 'Body', with: 'New task'
          click_on 'Save'

          expect(page).to_not have_content task.body
          expect(page).to have_content 'New task'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edited task with invalid attributes' do
        within '.tasks' do
          fill_in 'Body', with: nil
          click_on 'Save'

          expect(page).to have_content task.body
        end
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'not author tries edited task' do
      sign_in other_user
      visit project_path(project)
      expect(page).to_not have_content 'MyString'
      expect(page).to_not have_content 'MyText'
      expect(page).to have_content "The page you were looking for doesn't exist."
    end
  end

  scenario 'Unauthenticated user tires edited task' do
    visit project_path(project)

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
