require "application_system_test_case"

class ProjectsTest < ApplicationSystemTestCase
  setup do
    @project = projects(:one)
  end

  test "visiting the index" do
    visit projects_url
    assert_selector "h1", text: "Projects"
  end

  test "creating a Project" do
    visit projects_url
    click_on "New Project"

    fill_in "Fqdn", with: @project.fqdn
    fill_in "Is active", with: @project.is_active
    fill_in "User", with: @project.user_id
    fill_in "Uuid", with: @project.uuid
    click_on "Create Project"

    assert_text "Project was successfully created"
    click_on "Back"
  end

  test "updating a Project" do
    visit projects_url
    click_on "Edit", match: :first

    fill_in "Fqdn", with: @project.fqdn
    fill_in "Is active", with: @project.is_active
    fill_in "User", with: @project.user_id
    fill_in "Uuid", with: @project.uuid
    click_on "Update Project"

    assert_text "Project was successfully updated"
    click_on "Back"
  end

  test "destroying a Project" do
    visit projects_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Project was successfully destroyed"
  end
end
