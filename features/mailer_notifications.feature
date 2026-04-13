Feature: Mailer notifications

  Scenario: Password change sends a confirmation email
    Given I am logged in as a mailer test user
    When I change my password through the password form
    Then a password change email should be delivered

  Scenario: Creating a venue booking sends a confirmation email
    Given I am logged in as a mailer test user
    And a venue booking is ready for mailer testing
    When I submit the booking request directly
    Then a venue booking confirmation email should be delivered

  Scenario: Creating an equipment booking sends a confirmation email
    Given I am logged in as a mailer test user
    And an equipment booking is ready for mailer testing
    When I submit the booking request directly
    Then an equipment booking confirmation email should be delivered

  Scenario: Cancelling a venue booking sends a cancellation email
    Given I am logged in as a mailer test user
    And an existing venue booking is ready for cancellation mailer testing
    When I cancel the existing booking directly
    Then a venue booking cancellation email should be delivered

  Scenario: Cancelling an equipment booking sends a cancellation email
    Given I am logged in as a mailer test user
    And an existing equipment booking is ready for cancellation mailer testing
    When I cancel the existing booking directly
    Then an equipment booking cancellation email should be delivered