require 'rails_helper'

feature "User can edited projects", %q{
  In order change project, user can edited project
}do
  given(:user) { create(:user) }
  given!(:project) { create :project, author: user}

  context "Authenticated user tries" do
    background do 
      sign_in(user)
      visit projects_path
      click_on 'Edit'
    end

    scenario "edited project with valid attributes" do
      fill_in 'Title', with: 'New title'
      fill_in 'Description', with: 'New description'
      click_on 'Save'

      expect(page).to have_content "New title"
      expect(page).to have_content "New description"
    end
    scenario "edited project with invalid attributes" do
      fill_in 'Title', with: nil
      click_on 'Save'

      expect(page).to have_content "can't be blank"
    end
  end

  scenario "unauthenticated user tires edited project" do
    visit projects_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
