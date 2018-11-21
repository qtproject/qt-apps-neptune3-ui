Feature: Test the popups

    From main menu some popups are directly accessible.
    Just test if they open

  Scenario: Open and close the volume popup

      Given main menu is open
       When the volume button is tapped
      Then  the volume popup should appear
      When  the popup close button is clicked
      Then  the volume popup should not be there after '1' seconds of closing animation

  Scenario: Change the volume

      Given main menu is open
       When the volume button is tapped
      Then  the volume popup should appear
      When  the volume slider is moved 'upwards'
      Then  the volume slider value should be 'increased'
      When  the popup close button is clicked
