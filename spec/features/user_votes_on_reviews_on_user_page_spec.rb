require 'rails_helper'

feature "User votes on review on user_page" do
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

    visit user_path(user)
    expect(page).to have_content "Upvote"
    expect(page).to have_content "Downvote"

    first(:link, 'Upvote').click

    expect(page).to have_content "Votes: 1 Upvoted Downvote review_three"
    expect(page).not_to have_content "Votes: 1 Upvoted Downvote review_two"
  end

  scenario "User has already clicked 'Upvote' and clicks 'Upvote again'" do

    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'

    visit user_path(user)
    expect(page).to have_content "Upvote"
    expect(page).to have_content "Downvote"

    first(:link, 'Upvote').click

    expect(page).to have_content "Votes: 1 Upvoted Downvote review_three"
    expect(page).not_to have_content "Votes: 1 Upvoted Downvote review_two"

    first(:link, 'Upvoted').click

    expect(page).to have_content "Votes: 0 Upvote Downvote review_one"
  end

  scenario "User has already clicked 'Upvote' and clicks 'Downvote'" do

    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'

    visit user_path(user)
    expect(page).to have_content "Upvote"
    expect(page).to have_content "Downvote"

    first(:link, 'Upvote').click
    first(:link, 'Downvote').click

    expect(page).to have_content "Votes: -1 Upvote Downvoted review_three"
  end

  scenario "User has already clicked 'Downvote' and clicks 'Downvote' again" do

    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'

    visit user_path(user)
    expect(page).to have_content "Upvote"
    expect(page).to have_content "Downvote"

    first(:link, 'Downvote').click
    first(:link, 'Downvoted').click

    expect(page).to have_content "Votes: 0 Upvote Downvote review_three"
  end

  scenario "User has already clicked 'Downvote' and clicks 'Upvote'" do

    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'

    visit user_path(user)
    expect(page).to have_content "Upvote"
    expect(page).to have_content "Downvote"

    first(:link, 'Downvote').click
    first(:link, 'Upvote').click

    expect(page).to have_content "Votes: 1 Upvoted Downvote review_three"
  end
end
