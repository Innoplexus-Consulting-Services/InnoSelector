//
//  popOverInnoSelector.swift
//  InnoSelector
//
//  Created by gopinath.a on 25/06/18.
//

import Foundation
import UIKit

public class PopOverInnoSelector: UITableViewController, UIAdaptivePresentationControllerDelegate {
    
    //MARK:- UI Declaration
    @IBOutlet var selectorTableView: UITableView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var bottomContainerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    //MARK:- Completion Handler
    public var completionHandler:((SelectorFilterEvent, [Any]) -> Void)?
    
    //MARK:- Button Press Functionalities
    @IBAction func applyButtonPressed(_ sender: Any) {
        if isCustom{
            if innoSelectorViewModel.selectedValuesCustom.count != 0  {
                completionHandler!(.didApply, innoSelectorViewModel.selectedValuesCustom)
                
                DispatchQueue.main.async(execute: {
                    self.dismiss(animated: true, completion: nil)
                })
            }else {
                selectorTableView.shake()
            }
        }else {
            if innoSelectorViewModel.selectedValues.count != 0  {
                completionHandler!(.didApply, innoSelectorViewModel.selectedValues)
                DispatchQueue.main.async(execute: {
                    self.dismiss(animated: true, completion: nil)
                })
            }else {
                selectorTableView.shake()
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        if isCustom{
            completionHandler!(.didCancel, innoSelectorViewModel.selectedValuesCustom)
            DispatchQueue.main.async(execute: {
                self.dismiss(animated: true, completion: nil)
            })
        }else{
            completionHandler!(.didCancel, innoSelectorViewModel.selectedValues)
            DispatchQueue.main.async(execute: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    
    //MARK:- Public Functions
    /// It will set the color to the event buttons in the bottom
    ///
    /// - Parameter color: Button Color
    public func setButtonThemeColor(color:UIColor?) -> Void {
        buttonThemeColor = color
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
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() -> Void {

        // Table View Properties
        selectorTableView.rowHeight = UITableViewAutomaticDimension
        selectorTableView.estimatedRowHeight = 45
        selectorTableView.showsHorizontalScrollIndicator = false
        selectorTableView.delegate = self
        selectorTableView.dataSource = self
        
        // Button Configuration
        bottomContainerView.layer.borderWidth = 0.5
        bottomContainerView.layer.borderColor = UIColor.darkGray.cgColor
        cancelButton.layer.borderWidth = 0.5
        cancelButton.layer.borderColor = UIColor.darkGray.cgColor
        cancelButton.setTitleColor(buttonThemeColor, for: .normal)
        applyButton.backgroundColor = buttonThemeColor
        
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
        
        if !innoSelectorViewModel.isMultiselect{
            bottomContainerViewHeight.constant = 0
            bottomContainerView.isHidden = true
        }
    }
}

//MARK:- Extensions
extension PopOverInnoSelector{
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCustom {
            return innoSelectorViewModel.dataSourceCustom.count
        }else {
            return innoSelectorViewModel.dataSource.count
        }
        
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
