require 'rails_helper'

feature 'User can delete projects',%q{
  Authenticated user can delete project
}do
  given(:user) { create :user }
  given!(:project) { create :project }

  scenario "Authenticated user tries delete project" do
    sign_in user
    click_on 'Delete'
    expect(page).to_not have_content 'MyString'
  end
  
  scenario "Unauthenticated user tries delete project" do
    visit projects_path
    expect(page).to_not have_link 'Delete', href: project_path(project)
  end
end
