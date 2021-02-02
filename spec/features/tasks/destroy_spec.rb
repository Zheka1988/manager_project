require 'rails_helper'

feature 'User can delete projects',%q{
  Authenticated user can delete project
}do
  given(:user) { create :user }
  given(:project) { create :project, author: user }
  given!(:task) { create :task, project: project, author: user }

  scenario "Authenticated user tries delete project" do
    sign_in user
    visit project_path(project)
    within '.tasks' do
      click_on 'Delete'
      expect(page).to_not have_content 'MyText'
    end

  end
  
  scenario "Unauthenticated user tries delete project" do
    visit project_path(project)
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
