# Click Tap for iOS

This is a small SwiftUI Xcode project for iOS 16+.

## Included
- Start / Stop timer
- Fixed illustrative target in the middle of the app
- Adjustable interval (0.10–2.00 seconds)
- Unlimited, 10, 50, 100, or 500 count options
- Reset counter

## Important iOS limitation
This app counts and animates taps **inside its own screen only**. A normal iOS app cannot inject touch events into Free Fire or other unrelated apps, and this project does not provide system-wide auto-tapping.

## Build an IPA
1. Open `ClickTap.xcodeproj` in Xcode on a Mac.
2. Select the `ClickTap` target and set your own unique Bundle Identifier.
3. In **Signing & Capabilities**, select your Apple Developer team and enable automatic signing.
4. Select an iPhone device or a generic iOS device and build/archive.
5. In Organizer, choose **Distribute App** and export/sign the IPA using an available distribution method.

An IPA cannot be produced or signed here because it requires Apple's Xcode build tools and signing credentials.
