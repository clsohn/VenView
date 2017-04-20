require 'rails_helper'

feature "Add reviews" do
  # As an authenticated user
  # I want to add a review for a venue
  # So I can share my opinion

  before(:each) do
    venue = FactoryGirl.create(:venue)
  end

  scenario "I'm on the venue page I should see a Add New Review Button" do
    visit venue_path(venue)

    expect(page).to have_content 'Add New Review'
  end

  scenario "I'm on the venue page and logged in and can go to new review form" do
    user = FactoryGirl.create(:user)
    visit venue_path(venue)

    click_link 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'

    click_button 'Add New Review'
    expect(page).to have_content 'New Review Form'
    expect(page).to have_content 'Title'
    expect(page).to have_content 'Cost'
    expect(page).to have_content 'Sound Quality'
    expect(page).to have_content 'Parking/Accessibility'
    expect(page).to have_content 'Comments'
    expect(page).to have_content 'Submit Review'
  end

  scenario "I can successfully create a review" do
    user = FactoryGirl.create(:user)
    visit venue_path(venue)

    click_link 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'
    click_button 'Add New Review'

    fill_in 'Title', with: 'The new place'
    choose('cost-3')
    choose('sound-4')
    choose('parking-4')
    fill_in 'Comments', with: 'This is the new place that everyone likes'
    click_button 'Submit Review'

    expect(page).to have_content 'The new place'
    expect(page).to have_content 'This is the new place that everyone likes'
  end

  scenario "My review doesn't save if I don't provide a title" do
    user = FactoryGirl.create(:user)
    visit venue_path(venue)

    click_link 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'
    click_button 'Add New Review'

    fill_in 'Comments', with: 'This is the new place that everyone likes'
    click_button 'Submit Review'

    expect(page).to have_content 'Title cannot be blank'
    expect(page).not_to have_content 'This is the new place that everyone likes'
  end

  scenario "I don't see the new review form if I'm not logged in" do
    visit venue_path(venue)
    click_button 'Add New Review'

    expect(page).not_to have_content venue.name
    expect(page).to have_content 'Email'
    expect(page).to have_content 'Password'
  end

















end
