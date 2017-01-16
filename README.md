# JHTAlertController

[![Version](https://img.shields.io/cocoapods/v/JHTAlertController.svg?style=flat)](http://cocoapods.org/pods/JHTAlertController)
[![License](https://img.shields.io/cocoapods/l/JHTAlertController.svg?style=flat)](http://cocoapods.org/pods/JHTAlertController/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/JHTAlertController.svg?style=flat)](http://cocoapods.org/pods/JHTAlertController)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

![alt tag](https://github.com/jjessel/JHTAlertController/blob/master/img/dark.PNG)
![alt tag](https://github.com/jjessel/JHTAlertController/blob/master/img/light.PNG)
![alt tag](https://github.com/jjessel/JHTAlertController/blob/master/img/icon.PNG)

## Easy to use
JHTAlertController is an easy to use replacement for `UIAlertController`. You can customize the appearance of your alert to match the theme of your app.

```swift
// Setting up an alert with a title and message
let alertController = JHTAlertController(title: "Turtle", message: "In this alert we use a String for the title instead of an image.", preferredStyle: .alert)

// Create the action.
let cancelAction = JHTAlertAction(title: "Cancel", style: .cancel,  handler: nil)

// Create an action with a completionl handler.
let okAction = JHTAlertAction(title: "Ok", style: .default) { _ in
   print("Do something here!")
}

// Add the actions to the alert.
alertController.addAction(cancelAction)
alertController.addAction(okAction)

// Show the action
present(alertController, animated: true, completion: nil)
```

## Customize the Appearance

* Change Fonts
* Change Colors
* Add Icons


#### Alert
```swift
// Change the background color
alertController.alertBackgroundColor = .black

// Round the corners
alertController.hasRoundedCorners = true
```
#### Title Block 
```swift
// Use an image instead of text
alertController.titleImage = UIImage(named: "Turtle")
// If you add an image to the title block, you may need to set restrictTitleViewHeight to true, depending on the image size

// Change the color of the text
alertController.titleTextColor = .black

// Change the font
alertController.titleFont = .systemFont(ofSize: 18)

// Change the title block color
alertController.titleViewBackgroundColor = .black

// Add an icon image to the title block
let alertController = JHTAlertController(title: "Wow!", message: "You can even set an icon for the alert.", preferredStyle: .alert, iconImage: UIImage(named: "TurtleDark"))
```
#### Message 
```swift
// Change the font
alertController.messageFont = .systemFont(ofSize: 18)

/ Change thte text color
alertController.messageTextColor = .black
```
#### Button
```swift
// Change the color of the divider
alertController.dividerColor = .black

// Change the color of the button during the creation of the action
let blueAction = JHTAlertAction(title: "Blue", style: .default, bgColor: .blue, handler: nil)

// Change the color for all buttons of a specific action
alertController.setButtonBackgroundColorFor(.default, to: .blue)

// Change the text color for a specific action
alertController.setButtonTextColorFor(.default, to: .white)

// Change the font for a specific action
alertController.setButtonFontFor(.default, to: .systemFont(ofSize: 18))

// Change all action types to a specific color
alertController.setAllButtonBackgroundColors(to: .blue)
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
iOS 9.0 and higher

## Installation

### CocoaPods
JHTAlertController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JHTAlertController"
```
### Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage using Homebrew:
```
$ brew update
$ brew install carthage
```
To add JHTAlertController to your Xcode project using Carthage, update your Cartfile:
```
github "jjessel/JHTAlertController" ~> 0.2.3
```
Run ```carthage update``` to build the framework and drag the built JHTAlertController.framework into your Xcode project.

## Author

Jeremiah Jessel @ Jacuzzi Hot Tubs, LLC

## License

JHTAlertController is available under the MIT license. See the LICENSE file for more info.
