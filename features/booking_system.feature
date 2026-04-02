Feature: Booking System UI Flow

  Scenario: User completes venue booking
    Given I am on the welcome page
    When I go to login page
    And I navigate to venue booking
    Then I see venue details
    When I continue to confirmation
    And I finalize booking
    Then booking is successful

  Scenario: User searches for projector
    Given I am on main page
    When I search for "projector"
    Then I see projector results