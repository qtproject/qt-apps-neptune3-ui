When performing code reviews, it's the duty of reviewer to ensure the branch passes all tests before accepting it to be merged. The steps are the following:

## Ensure the qml tests pass

Simply run:
$ make check
And see that all tests have passed

## Perform some manual tests

All or most of the manual tests below should be automated (eg, made into qml tests). But while that doesn't happen, here they are.

### App launch
1. launch an application that is not already in the home screen by clicking on its icon in the launcher
2. Check that it shows up, maximized
3. Check that the bottom widgets is still displayed in front of it
4. Check that its corresponding icon in the launcher is highlighted
5. Click on the home button
6. Check that the home screen is visible again

### Adding removing widgets
1. Remove one of the existing widgets on the home screen (click on its "x" icon)
2. Click on the "+" icon at the bottom of the home screen and add that same application back again

### Launcher editing
1. Click on the launcher grid icon on its far right
2. Press and hold on the launcher area to get it into editing mode
3. Reorder an application icon
4. Click on "Finish Editing"
5. Click on the close "X" icon on the top right
