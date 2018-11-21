Feature: Test common app functionality

  Test some common app functionalities
  available from the main screen.

  Scenario Outline: Open settings app from launcher bar
  Given main menu is open
  And '<launcher apps>' app from launcher tapped
  Then wait '2' seconds and '<launcher apps>' app is active

   Examples:
  | launcher apps |
  |   settings    |
  |   calendar    |
