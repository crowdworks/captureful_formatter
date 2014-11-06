Feature: Example Web Application

  Scenario: access web application (SUCCESS)
    When I am on the "/"
    Then I should see "Monology"

  Scenario: access web application (FAILED)
    When I am on the "/"
    Then I should see "FAIL WORD"

  Scenario: post some tweets (SUCCESS)
    When I am on the "/"
     And type "Test Message" to "body"
     And click "tweet"
    Then I should see "Test Message"
