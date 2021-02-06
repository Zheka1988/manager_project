# frozen_string_literal: true

require 'rails_helper'

feature 'User can edited projects', '
  In order change project, user can edited project
' do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:project) { create :project, author: user }

  context 'Authenticated user ' do
    context 'Autor', js: true do
      background do
        sign_in(user)
        visit projects_path
        within "#project-#{project.id}" do
          click_on 'Edit'
        end
      end

      scenario 'tries edited project with valid attributes' do
        within "#project-#{project.id}" do
          fill_in 'Title', with: 'New title'
          fill_in 'Description', with: 'New description'
          click_on 'Save'
          expect(page).to_not have_content project.title
          expect(page).to_not have_content project.description
          expect(page).to have_content 'New title'
          expect(page).to have_content 'New description'
        end

      end

      scenario 'tries edited project with invalid attributes' do
        within "#project-#{project.id}" do
          fill_in 'Title', with: nil
          click_on 'Save'
        end
        expect(page).to have_content "Title can't be blank"
      end
    end

    scenario 'not author tries edited project' do
      sign_in other_user
      visit project_path(project)
      expect(page).to_not have_content 'MyText'
      expect(page).to have_content "The page you were looking for doesn't exist."
    end
  end

  scenario 'unauthenticated user tires edited project' do
    visit projects_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
