# InnoSelector
[![Language](https://img.shields.io/badge/language-Swift-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Supports](https://img.shields.io/badge/supports-CocoaPods%20%7C%20Carthage-green.svg?style=flat)](https://cocoapods.org/pods/InnoSelector)
[![License](https://img.shields.io/cocoapods/l/HeartLoadingView.svg?style=flat)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/cocoapods/p/HeartLoadingView.svg?style=flat)](https://developer.apple.com/)

## Description
A framework for data selection which has the option for both single and multi-select functionalities. In this, you can also customise the attributes like how the view should present, what will be the title and its colour, whether the table content should have the image or not, colour for the title and subtitle of the table content, bottom theme colour and much more.

## Example
To run the example project, clone the repo, and run `pod install` from the InnoSelectorDemo2 directory first.

Customisation              |  Single-Select/Multi-Select
:-------------------------:|:-------------------------:
![](https://github.com/Innoplexus-Consulting-Services/InnoSelector/blob/master/Assets/Clip1.gif)  |  ![](https://github.com/Innoplexus-Consulting-Services/InnoSelector/blob/master/Assets/Clip2.gif)

Push-View/PresentView      |  Fullscreen
:-------------------------:|:-------------------------:
![](https://github.com/Innoplexus-Consulting-Services/InnoSelector/blob/master/Assets/Clip3.gif)|  ![](https://github.com/Innoplexus-Consulting-Services/InnoSelector/blob/master/Assets/Clip4.gif)

Navigation Drop Down       |  Pop Over
:-------------------------:|:-------------------------:
![](https://github.com/Innoplexus-Consulting-Services/InnoSelector/blob/dev/Assets/Clip5.gif) |  ![](https://github.com/Innoplexus-Consulting-Services/InnoSelector/blob/dev/Assets/Clip6.gif)

## Requirements
- iOS 8.0+
- Xcode 9.2

## Usage
### Initialization:
1. For Bottom Sheet
```
let selectorFilter = InnoSelector.bottomSheet()
```
2. For PopOver
```
// Your class should implement UIAdaptivePresentationControllerDelegate
class ViewController: UIViewController, UIAdaptivePresentationControllerDelegate{

let selectorFilter = InnoSelector.popOver()

if let whatSender = sender as? UIBarButtonItem{
selectorFilter.popoverPresentationController?.barButtonItem = whatSender
}else{
selectorFilter.popoverPresentationController?.sourceView = sender as? UIView
}
selectorFilter.preferredContentSize = CGSize(width: 300, height: 400
selectorFilter.presentationController?.delegate = self

// Delegate Methods
func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
return UIModalPresentationStyle.none
}

func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
return UIModalPresentationStyle.none
}

}
```
3. For Navigation Dropdown(Supports only Single Select)
```
let selectorFilter = InnoSelector.navigationDropDown()
```
### Passing Data:
For now we are supporting only [Strings] and [CustomObjects]
```
var data: [InnoData] = []
var data2: [InnoData] = []
var data3:[String] =  []
var data4:[String] = []
var multiselecr: Bool = true

data = [CustomDataObject(image: <#T##UIImage?#>, primaryText: <#T##String#>, subText: <#T##String?#>)]
data3 = ["Gopi", "Asmita", "Jassi", "Manoj", "Dhiraj", "Suraj"]
```
For [Custom Data]
```
selectorFilter.setContent(dataSource: data, selectedValues: data2, isMultiselect: multiselecr, minSelection: 1, maxSelection: 10)
```
For [String]
```
selectorFilter.setContent(dataSource: data3, selectedValues: data4, isMultiselect: multiselecr, minSelection: 1, maxSelection: 10)
```
- Note: For Navigation Drop Down "isMultiselect" should be false.
### Presenting View:
1. For Bottom Sheet
```
var pushView: Bool = false

if pushView {
selectorFilter.push(viewController: self, innoSelector: selectorFilter)
}else{
selectorFilter.presentIn(viewController: self)
}
```
2. For PopOver
```
present(selectorFilter, animated: true, completion: nil)
```
3. For Navigation Dropdown
```
let selectorFilter = InnoSelector.navigationDropDown()
selectorFilter.present()
```
### Completion Handler:
```
selectorFilter.completionHandler = { event, selectedValues in
switch event {
case .didApply:
if let selectedData = selectedValues as? [InnoData]{
self.data2 = selectedData
}else{
self.data4 = selectedValues as! [String]
}
print(selectedValues.count)
case .didCancel:
print("Cancel")
}
}
```

## Customization
### For Bottom Sheet
1. Set FullScreen
```
selectorFilter.setFullScreen = true
```
2. Change Layout Height
```
selectorFilter.selectorViewHeight = 300.0
```
3. Set Title
```
selectorFilter.setTitle(title: "titleString", color: titleTextColor)
```
4. Set Button Theme
```
selectorFilter.setButtonThemeColor(color: UIColor.black)
```
5. Set Content Theme
```
selectorFilter.setContentTextColor(Title: tablePriText, subTitle: tableSubText)
```
6. Hide Top Bar
```
selectorFilter.hideTopBar = true
```
7. Set Font
```
selectorFilter.setTextLabelFont(name: "Avenir", size: 15)
selectorFilter.setDetailTextLabelFont(name: "Avenir", size: 15)
```
### For PopOver
1. Set Button Theme
```
selectorFilter.setButtonThemeColor(color: UIColor.black)
```
2. Set Content Theme
```
selectorFilter.setContentTextColor(Title: tablePriText, subTitle: tableSubText)
```
### For Navigation DropDown
1. Set Content Theme
```
selectorFilter.setContentTextColor(Title: tablePriText, subTitle: tableSubText)
```
2. Set Table Height
```
selectorFilter.tableHeight = 250
```
## Installation

InnoSelector is available through [CocoaPods](https://cocoapods.org/pods/InnoSelector). To install
it, simply add the following line to your Podfile:

```ruby
pod 'InnoSelector'
```

## Author

Gopinath A, gopinath.a@innoplexus.com

## License

InnoSelector is available under the MIT license. See the LICENSE file for more info.
