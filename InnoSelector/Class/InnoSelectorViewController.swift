//
//  InnoSelectorViewController.swift
//  InnoSelector
//
//  Created by gopinath.a on 24/05/18.
//  Copyright © 2018 innoplexus. All rights reserved.
//

import UIKit

public class InnoSelectorViewController: UIViewController {
    
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
    
    
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    //MARK:- Button Press Functionalities
    @IBAction func applyButtonPressed(_ sender: Any) {
        if innoSelectorViewModel.selectedValues.count != 0  {
            completionHandler!(.didApply, innoSelectorViewModel.selectedValues)
            dismiss()
        }else {
            selectorTableView.shake()
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        completionHandler!(.didCancel, innoSelectorViewModel.selectedValues)
        dismiss()
    }
    
    //MARK:- Completion Handler
    public var completionHandler:((SelectorFilterEvent, [CustomDataObject]) -> Void)?
    
    //MARK: - Public Variable Declaration
    public var setFullScreen:Bool = false
    public var selectorViewHeightConstant:CGFloat = CGFloat(260)
    
    //MARK:- Local variable declaration
    var innoSelectorViewModel = InnoSelectorCustomCellViewModel()
    
    var selectorTitleColor: UIColor? = UIColor.black
    var selectorTitleValue: String? = "SELECTOR"
    
    var cellPrimaryTextColor:UIColor? = UIColor.black
    var cellSubTextColor:UIColor? = UIColor.darkGray
    
    var buttonThemeColor:UIColor? = UIColor.black
    
    //MARK:- Storyboard Initialisation
    @objc public static func instantiate() -> InnoSelectorViewController {
        let storyboardsBundle = getStoryboardsBundle()
        let storyboard:UIStoryboard = UIStoryboard(name: "InnoSelectorViewController", bundle: storyboardsBundle)
        let popOverAlertViewController = storyboard.instantiateViewController(withIdentifier: "InnoSelectorViewController") as! InnoSelectorViewController
        
        return popOverAlertViewController
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
                self.title = selectorTitleValue != nil ? selectorTitleValue : "SELECTOR"
                let textAttributes = [NSAttributedStringKey.foregroundColor:selectorTitleColor]
                self.navigationController?.navigationBar.titleTextAttributes = selectorTitleColor != nil ? textAttributes : [NSAttributedStringKey.foregroundColor:UIColor.black]
            } else{
                selectorTitle.topItem?.title = selectorTitleValue != nil ? selectorTitleValue : "SELECTOR"
                let textAttributes = [NSAttributedStringKey.foregroundColor:selectorTitleColor]
                selectorTitle.titleTextAttributes = selectorTitleColor != nil ? textAttributes : [NSAttributedStringKey.foregroundColor:UIColor.black]
            }
            
        }else {
            mainContainerView.backgroundColor = UIColor.clear
            mainContainerViewHeight.constant = selectorViewHeightConstant
            selectorTitle.topItem?.title = selectorTitleValue != nil ? selectorTitleValue : "SELECTOR"
            let textAttributes = [NSAttributedStringKey.foregroundColor:selectorTitleColor]
            selectorTitle.titleTextAttributes = selectorTitleColor != nil ? textAttributes : [NSAttributedStringKey.foregroundColor:UIColor.black]
        }
        
        // Table View Properties
        selectorTableView.tableFooterView = UIView(frame: CGRect.zero)
        selectorTableView.rowHeight = CGFloat(44)
        selectorTableView.delegate = self
        selectorTableView.dataSource = self
        
        // Button Configuration
        let count = innoSelectorViewModel.dataSource.count
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
    public func setTableContent(dataSource: [CustomDataObject], selectedValues:[CustomDataObject] = [], isMultiselect: Bool, minSelection: Int,maxSelection: Int) -> Void {
        innoSelectorViewModel = InnoSelectorCustomCellViewModel(dataSource: dataSource, selectedValues: selectedValues, isMultiselect: isMultiselect, minSelection: minSelection, maxSelection: maxSelection)
    }
    
    /// It will set the text color for the conten in the table view
    ///
    /// - Parameters:
    ///   - primaryText: Color for the primary text
    ///   - subText: Color for the sub text
    public func setTableContentTextColor(primaryText: UIColor?, subText: UIColor?) -> Void {
        cellPrimaryTextColor = primaryText
        cellSubTextColor = subText
        
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
        let podBundle = Bundle(for: InnoSelectorViewController.self)
        let bundleURL = podBundle.url(forResource: "Storyboards", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)!
        
        return bundle
    }

}


//MARK:- Extensions
extension InnoSelectorViewController: UITableViewDelegate, UITableViewDataSource{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return innoSelectorViewModel.dataSource.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = selectorTableView.dequeueReusableCell(withIdentifier: "Custom") as! InnoSelectorCustomCellViewController
        cell.selectionStyle = .none
        
        let value = innoSelectorViewModel.dataSource[indexPath.row]
        
        if let color = cellPrimaryTextColor {
            cell.mainMessageColor = color
        }
        
        if let color = cellSubTextColor{
            cell.subMessageColor = color
        }
        
        cell.mainImage = innoSelectorViewModel.dataSource[indexPath.row].image
        cell.mainMessage = innoSelectorViewModel.dataSource[indexPath.row].mainText
        cell.subMessage = innoSelectorViewModel.dataSource[indexPath.row].subText
        
        if innoSelectorViewModel.selectedValues.contains(value) {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        cell.layoutSubviews()
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
