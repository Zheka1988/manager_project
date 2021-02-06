# frozen_string_literal: true

require 'rails_helper'

feature 'User can create project', '
  In order manage projects
  As an authenticated user can create project
' do
  given(:user) { create(:user) }

  describe 'Authenticated user tries' do
    background do
      sign_in(user)

      visit projects_path
    end

    scenario 'create project with valid attribute', js: true do
      within 'div.new-project' do
        fill_in 'Title', with: 'Name Project'
        fill_in 'Description', with: 'Description project'
        click_on 'Save'
      end
      expect(current_path).to eq projects_path
      project = user.authored_projects.first
      within "#project-#{project.id}" do
        expect(page).to have_content 'Name Project'
        expect(page).to have_content 'Description project'
      end
    end

    scenario 'create project with invalid attribute', js: true do
      within 'div.new-project' do
        click_on 'Save'
      end
      expect(current_path).to eq projects_path
      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user tries create project' do
    visit projects_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
