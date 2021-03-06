require 'rails_helper'

feature "User cannot vote if they are not logged in" do
  # As an authenticated user
  # I want to upvote
  # So that I know what reviews I found useful.

  scenario "Unauthenicated user does not see Vote Buttons" do
    venue = FactoryGirl.create(:venue)
    FactoryGirl.create(:review,
      venue: venue)

    visit venue_path(venue)

    expect(page).not_to have_selector(:css, "a.triangle-up")
    expect(page).not_to have_selector(:css, "a.triangle-down")
    expect(page).to have_content "Votes: 0"
  end
end

feature "Autheticated User can vote" do
  # As an authenticated user
  # I want to upvote
  # So that I know what reviews I found useful.

  let!(:venue) { FactoryGirl.create(:venue) }
  let!(:user) { FactoryGirl.create(:user) }

  let!(:review_one) do
    FactoryGirl.create(
      :review,
      title: "review_one",
      venue: venue,
      user: user
    )
  end

  let!(:review_two) do
    FactoryGirl.create(
      :review,
      title: "review_two",
      venue: venue,
      user: user
    )
  end

  let!(:review_three) do
    FactoryGirl.create(
      :review,
      title: "review_three",
      venue: venue,
      user: user
    )
  end

  scenario "User who has not already voted clicks 'Upvote' on a review" do

    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'

    visit venue_path(venue)
    expect(page).to have_selector(:css, "a.triangle-up")
    expect(page).to have_selector(:css, "a.triangle-down")

    first(:css, "a.triangle-up").click

    expect(page).to have_content "Votes: 1 review_three"
    expect(page).not_to have_content "Votes: 1 review_two"
  end

  scenario "User has already clicked 'Upvote' and clicks 'Upvote again'" do

    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'

    visit venue_path(venue)
    expect(page).to have_selector(:css, "a.triangle-up")
    expect(page).to have_selector(:css, "a.triangle-down")

    first(:css, "a.triangle-up").click

    expect(page).to have_content "Votes: 1 review_three"
    expect(page).not_to have_content "Votes: 1 review_two"

    first(:css, "a.triangle-up").click

    expect(page).to have_content "Votes: 0 review_three"
  end

  scenario "User has already clicked 'Upvote' and clicks 'Downvote'" do

    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'

    visit venue_path(venue)
    expect(page).to have_selector(:css, "a.triangle-up")
    expect(page).to have_selector(:css, "a.triangle-down")

    first(:css, "a.triangle-up").click
    first(:css, "a.triangle-down").click

    expect(page).to have_content "Votes: -1 review_three"
  end

  scenario "User has already clicked 'Downvote' and clicks 'Downvote' again" do

    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'

    visit venue_path(venue)
    expect(page).to have_selector(:css, "a.triangle-up")
    expect(page).to have_selector(:css, "a.triangle-down")

    first(:css, "a.triangle-down").click
    first(:css, "a.triangle-down").click

    expect(page).to have_content "Votes: 0 review_three"
  end

  scenario "User has already clicked 'Downvote' and clicks 'Upvote'" do

    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'

    visit venue_path(venue)
    expect(page).to have_selector(:css, "a.triangle-up")
    expect(page).to have_selector(:css, "a.triangle-down")

    first(:css, "a.triangle-down").click
    first(:css, "a.triangle-up").click

    expect(page).to have_content "Votes: 1 review_three"
  end

end
