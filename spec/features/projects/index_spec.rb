require 'rails_helper'

feature ' Any user can look projects', %q{
  Any user see the list of projects
} do
  given(:user) { create :user }
  given!(:projects) { create_list :project, 3, author: user }
  given(:other_user) { create :user }

  context 'Authenticated user' do
    
    scenario "Author can browse all his projects" do
      sign_in(user)
      visit projects_path
      expect(page).to have_content "MyString", count: 6
    end

    scenario "Not author can not browse projects of other people's " do
      sign_in other_user
      visit projects_path
      expect(page).to_not have_content "MyString"
    end
  end

  scenario 'unauthenticated user can browse all projects' do
    visit projects_path
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end

end
