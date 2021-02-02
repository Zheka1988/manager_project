require 'rails_helper'

feature ' Any user can look projects', %q{
  Any iser see the list of projects
} do
  given(:user) { create :user }
  given!(:projects) { create_list :project, 3, author: user }
  given(:other_user) { create :user }
  given!(:other_project) { Project.create(title: "Other project", description: "other other other", author: other_user) }

  scenario 'Authenticated user can browse all his projects' do
    sign_in(user)
    visit projects_path
    expect(page).to have_content "MyString", count: 6
    expect(page).to_not have_content "Other project"
  end

  scenario 'unauthenticated user can browse all projects' do
    visit projects_path
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end

end
