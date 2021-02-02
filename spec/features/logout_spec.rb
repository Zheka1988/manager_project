require 'rails_helper'

feature 'User can logout', %q{
  In order to complete work in the system,
  logged user can exit
} do
  given(:user) { create :user }

  scenario "logged user can logout system" do
    sign_in user
    click_on 'Logout'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario "unlogged user can not logout system" do
    visit projects_path
    expect(page).to_not have_link 'Logout', href: destroy_user_session_path
  end
end
