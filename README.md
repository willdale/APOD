# APOD (Astronomy Picture of the Day)

## Architecture

The project follows the MVVM design pattern, separating the view from the business logic. Dependencies, such as the Network Manager, are injected from the SwiftUI Environment.

Non-feature functionality is separated into modules using the Swift Package Manager. This allows for easier and more isolated testing of code. The modules create a public interface with testable internal functions that can’t be accessed from the main app but can be accessed from tests. Modularising the code base also helps with separating concerns; for example, the networking module contains only networking code.

## Testing

There are four testing modules in this app:

- Unit tests for the each Package
- Unit tests for the app module
- UI tests for the app module

The app is built using the principle of dependency inversion; for example, the `initialiser` to the `NetworkManager` is an existential type, allowing for tests to swap out the networking implementation for data mocking.

When the app opens, it checks for a launch argument to see if it is in UI test mode, which is then passed into Process the Environment. If it is in test mode, then mocked versions of the networking implementation will be used.

## Accessibility

The accessibility is relatively basic and works for VoiceOver, DynamicType, and VoiceControl. The main images don't react to Smart Invert.

## Future Improvements

- Move over to OS logger or another logging framework rather than print statements.
- A more robust caching system:
    - Add caching for AsyncImage, which would require a custom component.
    - Add storage of responses using the requests as the keys.    
- Custom navigation for iPads on iOS 16 and 17; iOS 18 defaults to a new navigation style as is.
- Localisation could be added through a Strings Catalogue.
- More tests should be written
