# sturdy-couscous-swiftui

A simple TOTP Authenticator App

![startup](https://github.com/Pierre81385/sturdy-couscous-swiftui/blob/main/assets/fulldemo.gif?raw=true)

# whats cool

- QR Code Scanner to extract the issuer, username, and secret from the QR code
    + automatically extract the issuer and username separate from the secret as substrings
- On scan the user is automatically redirected to the main screen and the passcode is displayed
- Once scanned the user can save this and regenerate the updated code anytime from the list
    + secret and timeinterval are saved through SwiftData 
