import UIKit
import XCTest
@testable import JHTAlertController

class Tests: XCTestCase {
   
   var alert: JHTAlertController!
   let testFont = UIFont.systemFont(ofSize: 18)
   
   override func setUp() {
      super.setUp()
      alert = JHTAlertController(title: "Test Message", message: "This is an alert. It is only an alert.", preferredStyle: .alert, iconImage: nil)
      
   }
   
   func testTitleBgColor() {
      alert.titleViewBackgroundColor = .black
      XCTAssertEqual(alert.titleViewBackgroundColor, .black)
   }
   
   func testAlertBgColor() {
      alert.alertBackgroundColor = .black
      XCTAssertEqual(alert.alertBackgroundColor, .black)
   }
   
   func testRoundedCorners() {
      alert.hasRoundedCorners = false
      XCTAssert(!alert.hasRoundedCorners)
   }
   
   func testTitleFont() {
      alert.titleFont = testFont
      XCTAssertEqual(alert.titleFont, testFont)
      
   }
   
   func testMessageFont() {
      alert.messageFont = testFont
      XCTAssertEqual(alert.messageFont, testFont)
   }
   
   func testTitleTextColor() {
      alert.titleTextColor = .black
      XCTAssertEqual(alert.titleTextColor, .black)
   }
   
   func testMessageTextColor() {
      alert.messageTextColor = .black
      XCTAssertEqual(alert.messageTextColor, .black)
   }
   
   func testNilIconImage() {
      XCTAssertNil(alert.titleImage)
      
   }
   func testAddingIconImage() {
      alert.titleImage = #imageLiteral(resourceName: "Turtle")
      XCTAssertNotNil(alert.titleImage)
   }
   
   func testTitleImage() {
      XCTAssertNil(alert.titleImage)
   }
   
   func testAddingTitleImage() {
      alert.titleImage = #imageLiteral(resourceName: "Turtle")
      XCTAssertNotNil(alert.titleImage)
   }
   
   func testDividerColor() {
      alert.dividerColor = .black
      XCTAssertEqual(alert.dividerColor, .black)
   }
   
   func testDefaultActionTextColors() {
      XCTAssertEqual(alert.buttonTextColor[.default], .white)
      XCTAssertEqual(alert.buttonTextColor[.cancel], .white)
      XCTAssertEqual(alert.buttonTextColor[.destructive], .red)
   }
   
   func testSettingActionTextColor() {
      alert.setButtonTextColorFor(.default, to: .black)
      XCTAssertEqual(alert.buttonTextColor[.default], .black)
   }
   
   func testDefaultActionBgColors() {
      XCTAssertEqual(alert.buttonBackgroundColor[.default], UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0))
      XCTAssertEqual(alert.buttonBackgroundColor[.cancel], UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0))
      XCTAssertEqual(alert.buttonBackgroundColor[.destructive], UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0))
   }
   
   func testSettingActionBgColor() {
      alert.setButtonBackgroundColorFor(.default, to: .black)
      XCTAssertEqual(alert.buttonBackgroundColor[.default], .black)
   }
   
   func testDefaultActionFont() {
      XCTAssertEqual(alert.buttonFont[.default], UIFont(name: "Avenir-Roman", size: 18)!)
      XCTAssertEqual(alert.buttonFont[.cancel], UIFont(name: "Avenir-Black", size: 18)!)
      XCTAssertEqual(alert.buttonFont[.destructive], UIFont(name: "Avenir-Roman", size: 18)!)
   }
   
   func testSettingActionFont() {
      alert.setButtonFontFor(.default, to: testFont)
      XCTAssertEqual(alert.buttonFont[.default], testFont)
   }
   
   func testAddActions() {
      let cancelAction = JHTAlertAction(title: "Cancel", style: .cancel,  handler: nil)
      let okAction = JHTAlertAction(title: "Yes", style: .default) { _ in
         print("Do something here!")
      }
      
      alert.addAction(cancelAction)
      alert.addAction(okAction)
      
      XCTAssertEqual(alert.actionCount, 2)
   }
   
   func testAddTextFields() {
      alert.addTextFieldWithConfigurationHandler { (textfield) in
         textfield.placeholder = "Test"
      }
      XCTAssertEqual(alert.textFields?.count, 1)
   }
   
   
   
   
}
