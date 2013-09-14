require File.expand_path(File.dirname(__FILE__) + '/support/features_spec_helper')

describe 'Rails App Demo', %q{
    As a user of this service
    I want to play with demo app
    So that I can understand how it works
  } do

  include_context "MyAcceptanceTest"

  it "creates new post", driver: :selenium do
    visit('/')

    expect(page).to have_content 'Hello, Rails!'

    click_link("My Blog")

    expect(page).to have_content 'Listing posts'

    click_link("New Post")

    expect(page).to have_content 'New post'

    fill_in "Name", :with => "name"
    fill_in "Title", :with => "title"
    fill_in "Content", :with => "content"
    fill_in "Tag", :with => "content"

    click_button("Create Post")

    expect(page).to have_content 'Post was successfully created'

    expect(page).to have_content 'Comments'

    fill_in "Commenter", :with => "commenter"
    fill_in "Body", :with => "body"

    click_button("Create Comment")

    click_link("Back to Posts")

    expect(page).to have_content 'Listing posts'
  end

end