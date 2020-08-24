require 'rails_helper'

RSpec.feature 'Friendships', type: :feature do
  let(:user1) do
    User.create(name: 'User', email: 'user@example.com', password: '123456', password_confirmation: '123456')
  end
  let(:user2) do
    User.create(name: 'Friend', email: 'friend@example.com', password: '123456', password_confirmation: '123456')
  end

  before :each do
    user1
    user2
    visit 'users/sign_in'
    within('#new_user') do
      fill_in 'user_email', with: user1.email
      fill_in 'user_password', with: user1.password
    end
    click_button 'Log in'
    visit '/users'
  end

  it 'should let the user send a friend request' do
    expect(page).to have_content('Send Friend Request')
    click_on('Send Friend Request')
    expect(page).to have_content('You have sent a friend request successfully!')
  end
end

RSpec.feature 'Friendships', type: :feature do
  let(:user1) do
    User.create(name: 'User', email: 'user@example.com', password: '123456', password_confirmation: '123456')
  end
  let(:user2) do
    User.create(name: 'Friend', email: 'friend@example.com', password: '123456', password_confirmation: '123456')
  end

  before :each do
    user1
    user2
    visit 'users/sign_in'
    within('#new_user') do
      fill_in 'user_email', with: 'user@example.com'
      fill_in 'user_password', with: '123456'
    end
    click_button 'Log in'
    visit '/users'
  end
  it 'should let the user accept a friend request' do
    click_on('Send Friend Request')
    click_on 'Sign out'
    visit root_path
    fill_in 'Email', with: user2.email
    fill_in 'Password', with: user2.password
    click_button 'Log in'
    click_on user2.name
    expect(page).to have_content('Accept')
    click_on('Accept')
    expect(page).to have_content('You have become friends!')
  end
end

RSpec.feature 'Friendships', type: :feature do
  let(:user1) do
    User.create(name: 'User', email: 'user@example.com', password: '123456', password_confirmation: '123456')
  end
  let(:user2) do
    User.create(name: 'Friend', email: 'friend@example.com', password: '123456', password_confirmation: '123456')
  end

  before :each do
    user1
    user2
    visit 'users/sign_in'
    within('#new_user') do
      fill_in 'user_email', with: 'user@example.com'
      fill_in 'user_password', with: '123456'
    end
    click_button 'Log in'
    visit '/users'
  end
  it 'should let the user reject a friend request' do
    click_on('Send Friend Request')
    click_on 'Sign out'
    visit root_path
    fill_in 'Email', with: user2.email
    fill_in 'Password', with: user2.password
    click_button 'Log in'
    click_on user2.name
    expect(page).to have_content('Delete')
    click_on('Delete')
    expect(page).to have_content('You have deleted friend request!')
  end
end
