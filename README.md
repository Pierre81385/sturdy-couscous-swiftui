# sturdy-couscous-swiftui

A simple TOTP Authenticator App

![startup](https://github.com/Pierre81385/sturdy-couscous-swiftui/blob/main/assets/Screenshot%202024-07-06%20at%205.03.24%E2%80%AFPM.png?raw=true)

# whats cool

- QR Code Scanner to extract the issuer, username, and secret from the QR code
    + automatically extract the issuer and username separate from the secret as substrings
- On scan the user is automatically redirected to the main screen and the passcode is displayed

![scanned](https://github.com/Pierre81385/sturdy-couscous-swiftui/blob/main/assets/IMG_8660.PNG?raw=true)

- Once scanned the user can save this and regenerate the updated code anytime from the list
    + secret and timeinterval are saved through SwiftData 

![saved](https://github.com/Pierre81385/sturdy-couscous-swiftui/blob/main/assets/IMG_8659.PNG?raw=true)
