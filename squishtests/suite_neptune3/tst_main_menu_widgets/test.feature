Feature: Main menu widget changes

    From main menu it is possible to change the widget,
    they are positioned horizontally.

    Scenario: Open and close add new widget popup

        Given main menu is open
         Then add widget was tapped
          And the new widget dialogue appeared
         When the popup close button is clicked
         Then the add widget popup should not be there after '1' seconds of closing animation

    Scenario: Add new widget maps

        Given main menu is open
         Then add widget was tapped
          And the new widget dialogue appeared
         When add map is tapped
         Then the 'map' widget is visible in the home screen
          And tapping close 'map' widget
          And the 'map' widget disappeared in the home screen after '1' seconds of animation

