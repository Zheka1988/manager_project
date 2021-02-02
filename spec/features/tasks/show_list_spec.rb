require 'rails_helper'

feature 'User can look tasks on project', %q{
  Only authenticated user can look task
} do
  given(:user) { create :user }
  given(:project) { create :project }
  given!(:tasks) { create_list :task, 3, project: project }

  scenario 'Authenticated user can browse all projects' do
    sign_in(user)
    visit project_path(project)
    expect(page).to have_content "MyText", count: 3
    expect(page).to have_content "2021-01-28 20:36:18"
  end

  scenario 'unauthenticated user can browse all projects' do
    visit project_path(project)
    expect(page).to_not have_content "MyText"
  end

end
