Feature: SendGrid API email delivery

  As the application
  In order to send transactional emails reliably through an external provider
  I want every mailer notification to be routed through the SendGrid Web API

  Background:
    Given the SendGrid API client is mocked for cucumber

  # ──────────────────────────────────────────────────────────────────────────
  Scenario: Booking confirmation email is dispatched via SendGrid API
    Given I am logged in as a sendgrid cucumber test user
    And a venue and time slot exist for sendgrid cucumber testing
    When I submit a booking for the sendgrid cucumber venue
    Then the SendGrid API should have received exactly 1 send requests
    And the sendgrid payload should be addressed to the logged-in user
    And the sendgrid payload subject should equal "Booking Confirmation"

  # ──────────────────────────────────────────────────────────────────────────
  Scenario: Equipment booking confirmation email is dispatched via SendGrid API
    Given I am logged in as a sendgrid cucumber test user
    And equipment and a time slot exist for sendgrid cucumber testing
    When I submit a booking for the sendgrid cucumber equipment
    Then the SendGrid API should have received exactly 1 send requests
    And the sendgrid payload should be addressed to the logged-in user
    And the sendgrid payload subject should equal "Booking Confirmation"

  # ──────────────────────────────────────────────────────────────────────────
  Scenario: Booking cancellation email is dispatched via SendGrid API
    Given I am logged in as a sendgrid cucumber test user
    And an existing venue booking is present for sendgrid cucumber testing
    When I cancel the sendgrid cucumber booking
    Then the SendGrid API should have received exactly 1 send requests
    And the sendgrid payload should be addressed to the logged-in user
    And the sendgrid payload subject should equal "Booking Cancellation"

  # ──────────────────────────────────────────────────────────────────────────
  Scenario: Password change email is dispatched via SendGrid API
    Given I am logged in as a sendgrid cucumber test user
    When I change my password via the sendgrid cucumber password form
    Then the SendGrid API should have received exactly 1 send requests
    And the sendgrid payload should be addressed to the logged-in user
    And the sendgrid payload subject should equal "Your password has been changed"
