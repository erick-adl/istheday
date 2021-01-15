# istheday

A new Flutter project.

# Clean Architecture and TDD for Real App Flutter

<br />

<h3 align="center">Clean Architecture</h3>

<br />

<img src="./clean_architecture.jpg" style="display: block; margin-left: auto; margin-right: auto; width: 75%;"/>


<br />

<h3 align="center">Architecture Proposal</h3>

<br />

<img src="./architecture-proposal.png" style="display: block; margin-left: auto; margin-right: auto; width: 75%;"/>


<br />
<br />

## First of all
### libraries and approaches:
```
dependencies:
  flutter:
    sdk: flutter

  get_it: ^3.1.0
  flutter_bloc: ^3.0.0
  equatable: ^1.0.1
  dartz: ^0.8.9
  data_connection_checker: ^0.3.4
  http: ^0.12.0+3
  shared_preferences: ^0.5.6

dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^4.1.1
```


## Getting Started

1. First you need to install [Flutter](https://flutter.dev/docs/get-started/install) and the setup as well.
2. Second you need to install [Android Studio](https://developer.android.com/studio/install) and [Xcode](https://developer.apple.com/xcode/) for the virtual device.
    Clone this repository
    ```
    git clone https://github.com/erick-adl/istheday.git
    ```
3. Open the project in your favorite IDE, in this case I'm using [VSCode](https://code.visualstudio.com/), install Dart plugin, then 
    cmd + shift + p, type Pub: Get Packages.
4. cmd + shift + p, type Flutter: Run Flutter Doctor, this command will help you to check if your flutter application can run on both android and ios platform.
5. Voila, now you can start the application, first navigate inside screeshot folder:
    ```
    cd istheday
    flutter run 
    or 
    To run the application you can press F5.

    ```

8. If you want to run this app on iOS, navigate to 
    ```
    istheday/ios
    ```
    then in terminal type: 
    ```
    pod install
    ```
This command will help you generate pods file to bundle the library to xcode emulator. See [cocoapods](https://cocoapods.org/)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.



