require 'rails_helper'

feature "User can edited projects", %q{
  In order change project, user can edited project
}do
  given(:user) { create(:user) }
  given(:project) { create :project, author: user }
  given!(:task) { create :task, project: project, author: user }

  context "Authenticated user tries" do
    background do 
      sign_in(user)
      visit project_path(project)
      within '.tasks' do
        click_on 'Edit'
      end
    end

    scenario "edited project with valid attributes" do
      fill_in 'Body', with: 'New task'
      click_on 'Save'

      expect(page).to have_content "New task"
      expect(page).to have_content "Your task has been successfully edited."
    end
    scenario "edited project with invalid attributes" do
      fill_in 'Body', with: nil
      click_on 'Save'

      expect(page).to have_content "can't be blank"
    end
  end

  scenario "unauthenticated user tires edited project" do
    visit project_path(project)
    
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
