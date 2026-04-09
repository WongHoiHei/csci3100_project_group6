Feature: Dashboard Navigation

  Scenario: Admin clicks the dashboard link
    Given I am on the main page
    When I follow "Dashboard"
    Then I should be on the dashboard page
    And I should see "Analytics Dashboard"