require 'rails_helper'

feature 'User can create project', %q{
  In order manage projects
  As an authenticated user can create project
} do
  given(:user) { create(:user) }
  
  describe 'Authenticated user tries' do
  
    background do
      sign_in(user)

      visit projects_path
      click_on 'New project'    
    end

    scenario 'create project with valid attribute' do
      fill_in 'Title', with: "Name Project"
      fill_in 'Description', with: 'Description project'
      click_on 'Save'

      expect(page).to have_content 'Your project successfully created.'
      expect(page).to have_content 'Name Project'
      expect(page).to have_content 'Description project'
    end

    scenario 'create project with invalid attribute' do    
      click_on 'Save'
      expect(page).to have_content "Title can't be blank"   
    end
  end

  scenario 'Unauthenticated user tries create project' do
    visit projects_path

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end

end
