require 'rails_helper'

RSpec.feature "PlaylistCreations", type: :feature do
  scenario "User creates a playlist" do
    user = User.create!(email: "user@example.com", username: "user1", password: "example")
    visit login_path
    fill_in "Username", with: "user1"
    fill_in "Password", with: "example"
    click_on "Sign In"
    expect(page).to have_text("Signed In!")
    visit new_playlist_path
    fill_in "Playlist Name", with: "The King Eternal Monarch"
    click_on "Search"
    expect(page).to have_text("The King: Eternal Monarch OST")
    first(:link, "The King: Eternal Monarch OST").click
    expect(page).to have_text("Successfully added playlist!")
  end

  scenario "Admin user deletes a playlist" do
    user = User.create!(email: "user@example.com", username: "user1", password: "example", admin: true)
    image_url = "https://pm1.narvii.com/7701/ee898219fecf4e37adef86e05119e0effe2b6aa7r1-794-1101v2_128.jpg"
    playlist = Playlist.create!(name: "test playlist", image_url: image_url, spotify_id: 1)
    visit login_path
    fill_in "Username", with: "user1"
    fill_in "Password", with: "example"
    click_on "Sign In"
    expect(page).to have_text("Signed In!")
    visit playlist_path(playlist)
    click_on "Delete Playlist"
    expect(page).to have_text("Playlist deleted.")
  end
end
