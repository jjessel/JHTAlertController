# JHTAlertController

[![Version](https://img.shields.io/cocoapods/v/JHTAlertController.svg?style=flat)](http://cocoapods.org/pods/JHTAlertController)
[![License](https://img.shields.io/cocoapods/l/JHTAlertController.svg?style=flat)](http://cocoapods.org/pods/JHTAlertController/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/JHTAlertController.svg?style=flat)](http://cocoapods.org/pods/JHTAlertController)



## Easy to use
JHTAlertController can be used as a replacement for the stock `UIAlertController`.
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

JHTAlertController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JHTAlertController"
```

## Author

Jeremiah Jessel @ Jacuzzi Hot Tubs, LLC

## License

JHTAlertController is available under the MIT license. See the LICENSE file for more info.
