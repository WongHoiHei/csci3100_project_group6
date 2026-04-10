Feature: Dashboard Analytics
  As a system administrator
  I want to view resource usage statistics
  So that I can make informed decisions about venue and equipment allocation

  Background:
    Given the following departments exist:
      | name                   |
      | Engineering Department |
      | Life Science Department|
    And "Engineering Department" has a venue "SHB301" with 10 bookings
    And "Engineering Department" has equipment "Projector" with 5 usages
    And I am logged in
    And I am on the dashboards page

  Scenario: Viewing initial analytics
    Then I should see "Resource Usage"
    And I should see a chart for "Venues"
    And I should see a chart for "Equipment"
    And the department selector should show "Engineering Department"

  @javascript
  Scenario: Filtering by department
    When I select "Life Science Department" from "tenant_id"
    Then the "Venues" chart should update to show data for "Life Science Department"
    And I should see "Life Science Department" in the department selector