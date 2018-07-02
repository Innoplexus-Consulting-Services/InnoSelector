//
//  InnoSelectorViewController.swift
//  InnoSelector
//
//  Created by gopinath.a on 24/05/18.
//  Copyright © 2018 innoplexus. All rights reserved.
//

import UIKit

public class InnoSelector: UIViewController {
    
    //MARK:- UI Declaration
    @IBOutlet var parentView: UIView!
 
    
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainContainerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var selectorTitle: UINavigationBar!
    @IBOutlet weak var selectorTopConstant: NSLayoutConstraint!
    @IBOutlet weak var selectorHeight: NSLayoutConstraint!
    
    @IBOutlet weak var selectorTableView: UITableView!
    
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var bottomContainerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    //MARK:- Button Press Functionalities
    @IBAction func applyButtonPressed(_ sender: Any) {
        if isCustom{
            if innoSelectorViewModel.selectedValuesCustom.count != 0  {
                completionHandler!(.didApply, innoSelectorViewModel.selectedValuesCustom)
                dismiss()
            }else {
                selectorTableView.shake()
            }
        }else {
            if innoSelectorViewModel.selectedValues.count != 0  {
                completionHandler!(.didApply, innoSelectorViewModel.selectedValues)
                dismiss()
            }else {
                selectorTableView.shake()
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        if isCustom{
            completionHandler!(.didCancel, innoSelectorViewModel.selectedValuesCustom)
            dismiss()
        }else{
            completionHandler!(.didCancel, innoSelectorViewModel.selectedValues)
            dismiss()
        }
    }
    
    //MARK:- Completion Handler
    public var completionHandler:((SelectorFilterEvent, [Any]) -> Void)?
    
    //MARK: - Public Variable Declaration
    public var setFullScreen:Bool = false
    public var selectorViewHeight:CGFloat = CGFloat(300)
    public var hideTopBar:Bool = false
    
    //MARK:- Storyboard Initialisation
    
    public static func bottomSheet() -> InnoSelector {
        
        let storyboardsBundle = getStoryboardsBundle()
        let storyboard:UIStoryboard = UIStoryboard(name: "InnoSelector", bundle: storyboardsBundle)
        let alertViewController = storyboard.instantiateViewController(withIdentifier: "InnoSelector") as! InnoSelector
        
        return alertViewController
    }
    
    public static func popOver() -> PopOverInnoSelector {
        
        let storyboardsBundle = getStoryboardsBundle()
        let storyboard:UIStoryboard = UIStoryboard(name: "InnoSelector", bundle: storyboardsBundle)
        let popOverAlertViewController = storyboard.instantiateViewController(withIdentifier: "PopOverInnoSelector") as! PopOverInnoSelector
        
        popOverAlertViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        popOverAlertViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 3)
        
        // arrow color
        popOverAlertViewController.popoverPresentationController?.backgroundColor = UIColor.white
        
        return popOverAlertViewController
    }
    
    public static func navigationDropDown() -> DropDownSelector{
        return dropDownSelector
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func changeMainViewContraints() -> Void {
        if #available(iOS 11.0, *) {
            mainContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            mainContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            
        } else {
            mainContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            mainContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        mainContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainContainerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    //MARK:- Base UI Setup
    func setupUI() -> Void {
        
        if !innoSelectorViewModel.isMultiselect{
            disableBottomContainer()
            bottomContainerView.isHidden = true
        }
        
        if hideTopBar {
            selectorTitle.isHidden = true
        }
        
        // Main Container Properties
        mainContainerView.applyShadow(cornerRadius: 0, color: UIColor.darkGray, opacity: 0.3, offsetWidth: 0, offsetHeight: -5)
        
        if self.navigationController != nil {
            if self.view.backgroundColor == UIColor.clear{
                view.backgroundColor = UIColor.white
            }
        }
        
        if setFullScreen {
            mainContainerView.translatesAutoresizingMaskIntoConstraints = false
            changeMainViewContraints()
            selectorTopConstant.constant = 0
            if self.navigationController != nil {
                selectorTitle.isHidden = true
                view.backgroundColor = UIColor.white
                selectorHeight.constant = 0
                self.title = selectorTitleValue != nil ? selectorTitleValue : "Title"
                let textAttributes = [NSAttributedStringKey.foregroundColor:selectorTitleColor]
                self.navigationController?.navigationBar.titleTextAttributes = selectorTitleColor != nil ? textAttributes : [NSAttributedStringKey.foregroundColor:UIColor.black]
            } else{
                selectorTitle.isHidden = true
                selectorHeight.constant = 0
                selectorTitle.topItem?.title = selectorTitleValue != nil ? selectorTitleValue : "Title"
                let textAttributes = [NSAttributedStringKey.foregroundColor:selectorTitleColor]
                selectorTitle.titleTextAttributes = selectorTitleColor != nil ? textAttributes : [NSAttributedStringKey.foregroundColor:UIColor.black]
            }
            
        }else {
            mainContainerView.backgroundColor = UIColor.clear
            mainContainerViewHeight.constant = selectorViewHeight
            selectorTitle.topItem?.title = selectorTitleValue != nil ? selectorTitleValue : "Title"
            let textAttributes = [NSAttributedStringKey.foregroundColor:selectorTitleColor]
            selectorTitle.titleTextAttributes = selectorTitleColor != nil ? textAttributes : [NSAttributedStringKey.foregroundColor:UIColor.black]
        }
        
        // Table View Properties
        selectorTableView.tableFooterView = UIView(frame: CGRect.zero)
//        selectorTableView.rowHeight = CGFloat(44)
        selectorTableView.delegate = self
        selectorTableView.dataSource = self
        
        // Button Configuration
        var count = 0
        if isCustom {
            count = innoSelectorViewModel.dataSourceCustom.count
        }else{
            count = innoSelectorViewModel.dataSource.count
        }
        if count == 0{
            applyButton.isUserInteractionEnabled = false
            applyButton.alpha = 0.2
            selectorTableView.showMessage(message: "NO DATA")
        }else{
            
            applyButton.isUserInteractionEnabled = true
            applyButton.alpha = 1.0
            selectorTableView.hideMessage()
        }
        
        bottomContainerView.layer.borderWidth = 0.5
        bottomContainerView.layer.borderColor = UIColor.darkGray.cgColor
        cancelButton.layer.borderWidth = 0.5
        cancelButton.layer.borderColor = UIColor.darkGray.cgColor
        cancelButton.setTitleColor(buttonThemeColor, for: .normal)
        applyButton.backgroundColor = buttonThemeColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelButtonPressed(_:)))
        dismissView.addGestureRecognizer(tapGesture)
        
    }
    
    
    //MARK:- Public Functions
    
    /// It will set the title string and color for that string
    ///
    /// - Parameters:
    ///   - title: String to be rendered as a Title
    ///   - color: Color for the Title
    public func setTitle(title:String?, color:UIColor?) -> Void {
        selectorTitleValue = title != "" ? title : selectorTitleValue
        selectorTitleColor = color
    }
    
    /// It will set the color to the event buttons in the bottom
    ///
    /// - Parameter color: Button Color
    public func setButtonThemeColor(color:UIColor?) -> Void {
        buttonThemeColor = color
    }
    
    /// It will get the data from the user and store that to the model class
    ///
    /// - Parameters:
    ///   - dataSource: Data's to be showed in the tableView
    ///   - selectedValues: Set of Data's that already selected by the user
    ///   - isMultiselect: It will ensure that the data selection is single select or multi select
    ///   - minSelection: Minimum number of selection that the user should select
    ///   - maxSelection: Maximun number of selection that the user can select
    public func setContent(dataSource: [Any], selectedValues: [Any] = [], isMultiselect: Bool = true, minSelection: Int = 1,maxSelection: Int = 100) -> Void {
        
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
    
    
    //MARK:- Private functions
    func disableBottomContainer() -> Void {
        bottomContainerViewHeight.constant = 0
    }
    
    func dismiss() -> Void {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        }else{
            DispatchQueue.main.async(execute: {
                self.dismiss(animated: true, completion: nil)
            })
            
        }
        
    }
    
    static func getStoryboardsBundle() -> Bundle {
        let podBundle = Bundle(for: InnoSelector.self)
        return podBundle
    }

}


//MARK:- Extensions
extension InnoSelector: UITableViewDelegate, UITableViewDataSource{
    
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
                applyButtonPressed(self)
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
                applyButtonPressed(self)
            }
        }
    }
    
}

extension UIView{
    
    func applyShadow(cornerRadius: CGFloat?, color: UIColor?, opacity: Float?, offsetWidth: CGFloat?, offsetHeight: CGFloat?) -> Void {
        self.layer.cornerRadius = (cornerRadius != nil) ? cornerRadius! : CGFloat(10.0)
        self.layer.shadowColor = (color != nil) ? color?.cgColor : UIColor.black.cgColor
        self.layer.shadowOffset = (offsetWidth != nil) ? CGSize(width: offsetWidth!, height: offsetHeight!) : CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = (opacity != nil) ? opacity! : Float(1.0)
        
    }
    
    func roundedCorners(radius: CGFloat) -> Void {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-15.0, 15.0, -15.0, 15.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
}

extension UITableView{
    
    func showMessage(message: String) -> Void {
        
        let messageLabel = UILabel(frame: CGRect(x: 0, y: self.frame.height+10, width: self.frame.width-50, height: 50))
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.text = message
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.center.x = self.center.x
        
        self.backgroundView = messageLabel
        
    }
    
    func hideMessage() -> Void {
        self.backgroundView = nil
    }
    
}

extension InnoSelector{
    
    public func presentIn(viewController: UIViewController, completion: (() -> Swift.Void)? = nil) -> Void {
        self.modalPresentationStyle = .overCurrentContext
        viewController.present(self, animated: true, completion: completion)
    }
    
    public func push(viewController: UIViewController, innoSelector: UIViewController) -> Void{
        viewController.navigationController?.pushViewController(innoSelector, animated: true)
    }
}
