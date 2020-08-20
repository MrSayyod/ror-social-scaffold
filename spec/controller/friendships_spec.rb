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
      fill_in 'user_email', with: 'user@example.com'
      fill_in 'user_password', with: '123456'
    end
    click_button 'Log in'
    visit '/users'
  end

  it 'should let the user send a friend request' do
    expect(page).to have_content('Send Friend Request')
  end

  it 'should let the user accept a friend request' do
    Friendship.create(user_id: user2.id, friend_id: user1.id, status: -1)
    click_link(user1.name)
    expect(page).to have_content('Accept')
  end

  it 'should let the user reject a friend request' do
    Friendship.create(user_id: user2.id, friend_id: user1.id, status: -1)
    click_link(user1.name)
    expect(page).to have_content('Delete')
  end
end