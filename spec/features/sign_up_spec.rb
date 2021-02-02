require 'rails_helper'

feature 'User can sign up', %q{
  In order to gain full access to the functionality of the system, 
  User can register in the system
} do
  scenario "User can registered in system" do
    visit new_user_registration_path
    fill_in 'Email', with: 'new_user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'    
  end
end
