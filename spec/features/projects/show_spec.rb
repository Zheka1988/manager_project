require 'rails_helper'

feature 'Any user can look his project' do
  given(:user) { create :user }
  given!(:project) { create :project, author: user }
  given(:other_user) { create :user }

  context 'Authenticated user' do
    
    scenario "Author can browse his project" do
      sign_in(user)
      visit project_path(project)
      expect(page).to have_content "MyString", count: 2
    end

    scenario "Not author can not browse project of other user " do
      sign_in other_user
      visit project_path(project)
      expect(page).to_not have_content "MyString"
      expect(page).to have_content "The page you were looking for doesn't exist."
    end
  end

  scenario 'unauthenticated user can browse project' do
    visit projects_path
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end

end
