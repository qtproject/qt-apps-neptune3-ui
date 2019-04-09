Feature: Test vehicle app functionality

  Test some features of the vehicle app.

Scenario Outline: Open vehicle app from launcher bar and switch

    Given main menu is open
#    And check that only single process is on
    And 'vehicle' app from launcher tapped
    Then wait '1' seconds and 'vehicle' app is active
    And tap vehicle view '<views>' button
    And vehicle view '<views>' should be displayed

  Examples:
    |  views   |
    | energy   |
    | support  |
    | doors    |
    |  tires   |


Scenario: Switch all driving support features

    Given main menu is open
#    And check that only single process is on
    And 'vehicle' app from launcher tapped
    Then wait '1' seconds and 'vehicle' app is active
    And tap vehicle view 'support' button
    And tap all support feature buttons, delaying '200' mseconds


Scenario Outline: Open and close all doors

    Given main menu is open
#    And check that only single process is on
    And 'vehicle' app from launcher tapped
    Then wait '1' seconds and 'vehicle' app is active
    And tap vehicle view 'doors' button
    And tap doors view '<subviews>' and open '<doors>' and close after '<delay>' msec

  Examples:
     | subviews  | doors   | delay |
     |  doors    | left    |  1500 |
     |  doors    | right   |  1500 |
     |  trunk    | trunk   |   500 |
     |  roof     | roof    |  1000 |
