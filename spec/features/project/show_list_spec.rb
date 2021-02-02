require 'rails_helper'

feature ' Any user can look projects', %q{
  Any iser see the list of projects
} do
  given(:user) { create :user }
  given!(:projects) { create_list(:project, 3) }

  scenario 'Authenticated user can browse all projects' do
    sign_in(user)
    visit projects_path
    expect(page).to have_content "MyString", count: 6
  end

  scenario 'unauthenticated user can browse all projects' do
    visit projects_path
    expect(page).to have_content "MyString", count: 6
  end

end
