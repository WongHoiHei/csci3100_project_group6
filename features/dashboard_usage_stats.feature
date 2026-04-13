Feature: Dashboard Usage Statistics
  As an administrator
  I want to see how many times venues and equipment have been used
  So that I can manage resource allocation effectively

  Background:
    Given a location exists named "Main Campus"
    And a venue exists named "Lab A" in "Main Campus"
    And a venue exists named "Lab B" in "Main Campus"
    And I am logged in as a "Test User"

  Scenario: Viewing resource usage counts
    Given a time slot exists for "Lab A" from "09:00" to "11:00"
    And a booking exists for "Lab A" with status "approved"
    And a booking exists for "Lab A" with status "pending"
    And a booking exists for "Lab A" with status "rejected"
    And a booking exists for "Oscilloscope" with status "approved"
    When I visit the dashboard page
    Then I should see "2" usage counts for "Lab A"
    And I should see "0" usage counts for "Lab B"
    And I should see "1" usage counts for "Oscilloscope"