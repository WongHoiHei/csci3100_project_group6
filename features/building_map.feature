Feature: Building Map Display
  As a user
  I want to view the campus map and click on buildings
  So that I can see information about specific facilities

  Background:
    Given a default tenant and user exist
    And I am logged into the system

  Scenario: Successfully accessing the map page
    When I go to the "map page"
    Then I should see the "map" element

  Scenario: Clicking a building to see details
    When I go to the "map page"
    And I click on the map marker for "Sir Run Run Shaw Hall"
    Then I should see "Sir Run Run Shaw Hall" in the building info section
    And the page should be rendered without the main layout