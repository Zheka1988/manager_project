require 'rails_helper'

feature "User can browse his task" do
  
  let(:user) { create :user }
  let(:other_user) { create :user }
  let(:project) { create :project, author: user }
  let!(:task) { create :task, project: project, author: user}

  context "Authenticate user" do
    context "Author" do   
      scenario "can view the task" do
        sign_in user
        visit project_path(project)
        within '.tasks' do
          click_on 'Show'
        end
        expect(page).to have_content "MyText"
        expect(page).to have_content "2021-01-28 20:36:18"
      end
    end

    scenario "Not author" do
      sign_in other_user
      visit project_path(project)
      expect(page).to_not have_content "MyText"
      expect(page).to have_content "The page you were looking for doesn't exist."
    end
  end

  scenario "Unauthenticate user" do
    visit project_path(project)
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
