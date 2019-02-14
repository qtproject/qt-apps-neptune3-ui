Feature: Test the popups

    From the home screen the volume popup is directly accessible.

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
