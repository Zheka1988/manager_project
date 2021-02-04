# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete projects', '
  Authenticated user can delete project
' do
  given(:user) { create :user }
  given(:other_user) { create :user }
  given!(:project) { create :project, author: user }

  context 'Authenticated user' do
    scenario 'author tries delete project' do
      sign_in user
      visit projects_path
      click_on 'Delete'
      expect(page).to_not have_content 'MyString'
    end

    scenario 'not author tries delete project' do
      sign_in other_user
      visit projects_path
      expect(page).to_not have_link 'Delete', href: project_path(project)
      expect(page).to_not have_content 'MyString'
    end
  end

  scenario 'Unauthenticated user tries delete project' do
    visit projects_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
