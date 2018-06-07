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
![](https://github.com/Innoplexus-Consulting-Services/InnoSelector/blob/master/Assets/Clip1.gif)      |  ![](https://github.com/Innoplexus-Consulting-Services/InnoSelector/blob/master/Assets/Clip2.gif)

Push-View/PresentView      |  Fullscreen
:-------------------------:|:-------------------------:
![](https://github.com/Innoplexus-Consulting-Services/InnoSelector/blob/master/Assets/Clip3.gif)                      |  ![](https://github.com/Innoplexus-Consulting-Services/InnoSelector/blob/master/Assets/Clip4.gif)

## Requirements
- iOS 8.0+
- Xcode 9.2

## Usage
- Initialization:
```
let selectorFilter = InnoSelector.instantiate()
```
- Passing Data:
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
- Presenting View:
```
var pushView: Bool = false

if pushView {
selectorFilter.push(viewController: self, innoSelector: selectorFilter)
}else{
selectorFilter.presentIn(viewController: self)
}
```
- Completion Handler:
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
5. Hide Top Bar
```
selectorFilter.hideTopBar = true
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
