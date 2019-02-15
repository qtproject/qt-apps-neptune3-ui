Feature: Test the climate popup features

    The climate popup has certain functionality.
    This will be tested here.

    Scenario: test some of the climate buttons

        Given main menu is open
        And the climate area is tapped
        And switch app to 'climate'
        Then select climate button 'recirculation'
        And climate button 'recirculation' shall be checked
        And click the popup close button

#    Scenario: test the climate slider left slide upwards
#
#        Given main menu is open
#        And the climate area is tapped
#         When the 'left' climate slider is moved 'upwards'
#         Then the climate slider value on the 'left' should 'increase'
#          And click the popup close button
