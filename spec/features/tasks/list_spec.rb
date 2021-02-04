# frozen_string_literal: true

require 'rails_helper'

feature 'User can look his tasks on his project', '
  Only authenticated user can look task
' do
  given(:user) { create :user }
  given(:project) { create :project, author: user }
  given!(:tasks) { create_list :task, 3, project: project, author: user }
  given(:other_user) { create :user }

  context 'Authenticated user' do
    scenario 'Author can browse all his tasks' do
      sign_in(user)
      visit project_path(project)
      within '.tasks' do
        expect(page).to have_content 'MyText', count: 3
        expect(page).to have_content '2021-01-28 20:36:18', count: 3
      end
    end

    scenario "Not author can not browse other people's tasks" do
      sign_in other_user
      visit project_path(project)
      expect(page).to_not have_content 'MyString'
      expect(page).to_not have_content 'MyText'
      expect(page).to have_content "The page you were looking for doesn't exist."
    end
  end

  scenario 'unauthenticated user can browse all tasks' do
    visit project_path(project)
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
