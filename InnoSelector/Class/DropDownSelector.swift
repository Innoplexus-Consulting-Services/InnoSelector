//
//  DropDownSelector.swift
//  InnoSelector
//
//  Created by gopinath.a on 28/06/18.
//

import UIKit

open class DropDownSelector: UITableView {
    
    fileprivate weak var navigationController: UINavigationController?
    fileprivate var topSeparator: UIView!
    
    let blackView = UIView()
    
    public var selectorTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    public var tableHeight: CGFloat = 0
    
    
    public func present() {
        
        //show menu
        
        if let window = UIApplication.shared.keyWindow {
            
            tableHeight = tableHeight != 0 ? tableHeight : CGFloat(innoSelectorViewModel.dataSource.count * 45)
            
            self.navigationController = window.rootViewController?.topMostViewController?.navigationController
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addTapGestureRecognizer {
                self.cancelButtonPressed()
            }
            
            selectorTableView.rowHeight = UITableViewAutomaticDimension
            selectorTableView.estimatedRowHeight = 45
            selectorTableView.showsHorizontalScrollIndicator = false
            selectorTableView.delegate = self
            selectorTableView.dataSource = self
            
            window.addSubview(blackView)
            
            window.addSubview(selectorTableView)
            
            selectorTableView.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)! + 0.5 , width: window.frame.width, height: 0)
            
            blackView.frame = CGRect(x: window.bounds.origin.x, y: (self.navigationController?.navigationBar.frame.maxY)!, width: window.frame.width, height: window.frame.height)
            blackView.alpha = 0
            
        }
        
        if isShown {
            cancelButtonPressed()
        }else{
            show()
        }
    }
    
    //MARK:- Completion Handler
    public var completionHandler:((SelectorFilterEvent, [Any]) -> Void)?
    
    public func setContent(dataSource: [Any], selectedValues: [Any] = [], isMultiselect: Bool = false, minSelection: Int = 1,maxSelection: Int = 100) -> Void {
        
        if let data = dataSource as? [InnoData] {
            isCustom = true
            // obj is a string array. Do something with stringArray
            innoSelectorViewModel = InnoSelectorCustomCellViewModel(dataSource: data, selectedValues: selectedValues as! [InnoData], isMultiselect: isMultiselect, minSelection: minSelection, maxSelection: maxSelection)
        }
        else if let data = dataSource as? [String] {
            innoSelectorViewModel = InnoSelectorCustomCellViewModel(dataSource: data, selectedValues: selectedValues as! [String], isMultiselect: isMultiselect, minSelection: minSelection, maxSelection: maxSelection)
        }
        
    }
    
    /// It will set the text color for the conten in the table view
    ///
    /// - Parameters:
    ///   - primaryText: Color for the primary text
    ///   - subText: Color for the sub text
    public func setContentTextColor(Title: UIColor?, subTitle: UIColor?) -> Void {
        cellPrimaryTextColor = Title
        cellSubTextColor = subTitle
    }
    
    /// Sent font for textLabel
    ///
    /// - Parameters:
    ///   - name: Font Name
    ///   - size: Font Size
    public func setTextLabelFont(name: String, size: CGFloat? = 18) -> Void {
        textLabelFont = name
        textLabelSize = size
    }
    
    /// Sent font for detailTextLabel
    ///
    /// - Parameters:
    ///   - name: Font Name
    ///   - size: Font Size
    public func setDetailTextLabelFont(name: String, size: CGFloat? = 14) -> Void {
        detailTextLabelFont = name
        detailTextLabelSize = size
    }
    
    func applyButtonPressed() -> Void {
        if isCustom{
            if innoSelectorViewModel.selectedValuesCustom.count != 0  {
                completionHandler!(.didApply, innoSelectorViewModel.selectedValuesCustom)
                self.dismiss()
            }else {
                selectorTableView.shake()
            }
        }else {
            if innoSelectorViewModel.selectedValues.count != 0  {
                completionHandler!(.didApply, innoSelectorViewModel.selectedValues)
                self.dismiss()
            }else {
                selectorTableView.shake()
            }
        }
    }
    
    
    func cancelButtonPressed() {
        if isCustom{
            completionHandler!(.didCancel, innoSelectorViewModel.selectedValuesCustom)
            self.dismiss()
            
        }else{
            completionHandler!(.didCancel, innoSelectorViewModel.selectedValues)
            self.dismiss()
            
        }
    }
    
    func show() -> Void {
        
        isShown = true
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 1
            
            self.selectorTableView.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)! + 0.5 , width: self.selectorTableView.frame.width, height: self.tableHeight)
            
        }, completion: nil)
    }
    
    func dismiss() -> Void {
        
        isShown = false
        
        self.selectorTableView.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)! + 0.5, width: self.selectorTableView.frame.width, height: tableHeight)
        
        UIView.animate(withDuration: 0.2) {
            self.blackView.alpha = 0
            
            self.selectorTableView.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)! + 0.5, width: self.selectorTableView.frame.width, height: 0)
            
        }
    }

}

extension DropDownSelector: UITableViewDelegate, UITableViewDataSource{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCustom {
            return innoSelectorViewModel.dataSourceCustom.count
        }else {
            return innoSelectorViewModel.dataSource.count
        }
        
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Custom")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Custom")
        }
        cell?.selectionStyle = .none
        
        if isCustom {
            let value = innoSelectorViewModel.dataSourceCustom[indexPath.row]
            
            cell?.imageView?.sizeToFit()
            cell?.textLabel?.textColor = cellPrimaryTextColor
            cell?.detailTextLabel?.textColor = cellSubTextColor
            if textLabelFont != nil{
                cell?.textLabel?.font = UIFont(name: textLabelFont!, size: textLabelSize!)
            }
            
            if detailTextLabelFont != nil{
                cell?.detailTextLabel?.font = UIFont(name: detailTextLabelFont!, size: detailTextLabelSize!)
            }
            cell?.imageView?.image = innoSelectorViewModel.dataSourceCustom[indexPath.row].image
            cell?.textLabel?.text = innoSelectorViewModel.dataSourceCustom[indexPath.row].mainText
            cell?.detailTextLabel?.text = innoSelectorViewModel.dataSourceCustom[indexPath.row].subText
            
            if innoSelectorViewModel.selectedValuesCustom.contains(value) {
                cell?.accessoryType = .checkmark
            }else{
                cell?.accessoryType = .none
            }
            return cell!
        } else {
            let value = innoSelectorViewModel.dataSource[indexPath.row]
            cell?.textLabel?.textColor = cellPrimaryTextColor
            if textLabelFont != nil{
                cell?.textLabel?.font = UIFont(name: textLabelFont!, size: textLabelSize!)
            }
            cell?.textLabel?.text = innoSelectorViewModel.dataSource[indexPath.row]
            
            if innoSelectorViewModel.selectedValues.contains(value) {
                cell?.accessoryType = .checkmark
            }else{
                cell?.accessoryType = .none
            }
            return cell!
        }
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isCustom {
            let value = innoSelectorViewModel.dataSourceCustom[indexPath.row]
            
            if innoSelectorViewModel.isMultiselect{
                // Check if present already and remove
                if innoSelectorViewModel.selectedValuesCustom.contains(value){
                    if let index = innoSelectorViewModel.selectedValuesCustom.index(where: { (object) -> Bool in
                        if object == value{
                            return true
                        }
                        return false
                    }){
                        if innoSelectorViewModel.selectedValuesCustom.count > innoSelectorViewModel.minSelection{
                            innoSelectorViewModel.selectedValuesCustom.remove(at: index)
                        }else{
                            tableView.shake()
                        }
                    }
                }else{
                    if innoSelectorViewModel.selectedValuesCustom.count < innoSelectorViewModel.maxSelection{
                        innoSelectorViewModel.selectedValuesCustom.append(value)
                    }else{
                        
                    }
                }
                selectorTableView.reloadData()
                
            }else{
                innoSelectorViewModel.selectedValuesCustom.removeAll()
                innoSelectorViewModel.selectedValuesCustom.append(value)
                selectorTableView.reloadData()
                applyButtonPressed()
            }
        } else {
            let value = innoSelectorViewModel.dataSource[indexPath.row]
            
            if innoSelectorViewModel.isMultiselect{
                // Check if present already and remove
                if innoSelectorViewModel.selectedValues.contains(value){
                    if let index = innoSelectorViewModel.selectedValues.index(where: { (object) -> Bool in
                        if object == value{
                            return true
                        }
                        return false
                    }){
                        if innoSelectorViewModel.selectedValues.count > innoSelectorViewModel.minSelection{
                            innoSelectorViewModel.selectedValues.remove(at: index)
                        }else{
                            tableView.shake()
                        }
                    }
                }else{
                    if innoSelectorViewModel.selectedValues.count < innoSelectorViewModel.maxSelection{
                        innoSelectorViewModel.selectedValues.append(value)
                    }else{
                        
                    }
                }
                selectorTableView.reloadData()
                
            }else{
                innoSelectorViewModel.selectedValues.removeAll()
                innoSelectorViewModel.selectedValues.append(value)
                selectorTableView.reloadData()
                applyButtonPressed()
            }
        }
    }
    
}

extension UIView {
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
}

internal extension UIViewController {
    // Get ViewController in top present level
    var topPresentedViewController: UIViewController? {
        var target: UIViewController? = self
        while (target?.presentedViewController != nil) {
            target = target?.presentedViewController
        }
        return target
    }
    
    // Get top VisibleViewController from ViewController stack in same present level.
    // It should be visibleViewController if self is a UINavigationController instance
    // It should be selectedViewController if self is a UITabBarController instance
    var topVisibleViewController: UIViewController? {
        if let navigation = self as? UINavigationController {
            if let visibleViewController = navigation.visibleViewController {
                return visibleViewController.topVisibleViewController
            }
        }
        if let tab = self as? UITabBarController {
            if let selectedViewController = tab.selectedViewController {
                return selectedViewController.topVisibleViewController
            }
        }
        return self
    }
    
    // Combine both topPresentedViewController and topVisibleViewController methods, to get top visible viewcontroller in top present level
    var topMostViewController: UIViewController? {
        return self.topPresentedViewController?.topVisibleViewController
    }
}

