Feature: Test the climate popup features

    The climate popup has certain functionality.
    This will be tested here.

    Scenario: test the climate slider left slide downward

        Given main menu is open
        And the climate area is tapped
         When the left climate slider is moved downwards2
         Then the climate slider value on the 'left' should 'decrease'

    Scenario: test the climate slider right slide downwards

        Given main menu is open
        And the climate icon is tapped

         When the right climate slider is moved upwards
         Then the climate slider value on the 'right' should 'increase'
