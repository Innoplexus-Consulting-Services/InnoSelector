//
//  ViewController.swift
//  InnoSelectorDemo2
//
//  Created by gopinath.a on 29/05/18.
//  Copyright © 2018 Innoplexus. All rights reserved.
//

import UIKit
import InnoSelector

class ViewController: UIViewController, UIAdaptivePresentationControllerDelegate{
    
    var data: [InnoData] = []
    var data2: [InnoData] = []
    var data3:[String] =  []
    var data4:[String] = []
    
    var multiselecr: Bool = false
    var pushView: Bool = false
    
    var gopi:DropDownSelector? = nil
    

    @IBOutlet weak var titleInfoLable: UILabel!
    @IBOutlet weak var buttonInfoLable: UILabel!
    @IBOutlet weak var tableInfoLable: UILabel!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var tableView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var titleText: UITextField!
    
    @IBOutlet weak var titleColor: UISegmentedControl!
    @IBOutlet weak var buttonColor: UISegmentedControl!
    @IBOutlet weak var tablePriColor: UISegmentedControl!
    @IBOutlet weak var tableSubColor: UISegmentedControl!
    
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var popButton: UIButton!
    
    var titleTextColor = UIColor.blue
    var tablePriText = UIColor.blue
    var tableSubText = UIColor.blue
    var buttonThemeColor = UIColor.blue
    
    var titleString = "Title"
    var setFullScreen:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        self.hideKeyboardWhenTappedAround()
        let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Drop Down", style: .plain, target: self, action: #selector(ViewController.performTask))
        let barButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Pop Selector", style: .plain, target: self, action: #selector(ViewController.openAlert(sender:)))
        self.navigationItem.rightBarButtonItem = barButtonItem
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        self.title = "InnoSelector"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:titleTextColor]
        setConerRadius()
        
        data3 = ["Gopi", "Asmita", "Jassi", "Manoj", "Dhiraj", "Suraj"]
        data =  [InnoData(image: #imageLiteral(resourceName: "far_cry_3_beach_game_graphics_hdr_95932_1920x1080"), mainText: "Farcry 3", subText: "Ubisoft"), InnoData(image: nil, mainText: "Content without Image", subText: "InnoSelector"), InnoData(image: #imageLiteral(resourceName: "far_cry_primal_action_adventure_ubisoft_montreal_106127_1920x1190"), mainText: "Farcry Primal", subText: "Ubisoft"),InnoData(image: #imageLiteral(resourceName: "tomb_raider_definitive_edition_crystal_dynamics_lara_croft_93180_2880x1800"), mainText: "Tomb Raider", subText: "Square Enix"),InnoData(image: nil, mainText: "Content without Image and SubText", subText: nil)]
        
    }
    
    func setConerRadius() -> Void {
        titleView.layer.cornerRadius = 5
        tableView.layer.cornerRadius = 5
        bottomView.layer.cornerRadius = 5
        
        titleView.layer.masksToBounds = true
        tableView.layer.masksToBounds = true
        bottomView.layer.masksToBounds = true
        
        showButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        showButton.layer.cornerRadius = 5
        showButton.layer.masksToBounds = true
        
        popButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        popButton.layer.cornerRadius = 5
        popButton.layer.masksToBounds = true
        
    }
    @IBAction func titleColorChanges(_ sender: Any) {
        switch titleColor.selectedSegmentIndex {
        case 0: return titleTextColor = UIColor.blue
        case 1: return titleTextColor = UIColor.orange
        case 2: return titleTextColor = UIColor.black
        case 3: return titleTextColor = UIColor.red
            
        default:
            titleTextColor = UIColor.blue
        }
    }
    @IBAction func buttonColorChnaged(_ sender: Any) {
        switch buttonColor.selectedSegmentIndex {
        case 0: return buttonThemeColor = UIColor.blue
        case 1: return buttonThemeColor = UIColor.orange
        case 2: return buttonThemeColor = UIColor.black
        case 3: return buttonThemeColor = UIColor.red
            
        default:
            buttonThemeColor = UIColor.blue
        }
    }
    @IBAction func tablePriColorChanged(_ sender: Any) {
        switch tablePriColor.selectedSegmentIndex {
        case 0: return tablePriText = UIColor.blue
        case 1: return tablePriText = UIColor.orange
        case 2: return tablePriText = UIColor.black
        case 3: return tablePriText = UIColor.red
            
        default:
            tablePriText = UIColor.blue
        }
    }
    @IBAction func tableSubColorChnaged(_ sender: Any) {
        switch tableSubColor.selectedSegmentIndex {
        case 0: return tableSubText = UIColor.blue
        case 1: return tableSubText = UIColor.orange
        case 2: return tableSubText = UIColor.black
        case 3: return tableSubText = UIColor.red
            
        default:
            tableSubText = UIColor.blue
        }
    }
    
    @IBAction func pushView(_ sender: Any) {
        if (sender as AnyObject).isOn {
            pushView = true
        }else {
            pushView = false
        }
    }
    
    @IBAction func multiselect(_ sender: Any) {
        
        if (sender as AnyObject).isOn {
            multiselecr = true
        }else {
            multiselecr = false
        }
    }
    
    @IBAction func setFullscreen(_ sender: Any) {
        if (sender as AnyObject).isOn {
            setFullScreen = true
        }else {
            setFullScreen = false
        }
    }
    
    @objc public func openAlert(sender:Any) {
        let selectorFilter = InnoSelector.popOver()
        
        if let whatSender = sender as? UIBarButtonItem{
            selectorFilter.popoverPresentationController?.barButtonItem = whatSender
        }else{
            selectorFilter.popoverPresentationController?.sourceView = sender as? UIView
        }
        selectorFilter.preferredContentSize = CGSize(width: 300, height: 55 * (data3.count - 1))
        selectorFilter.presentationController?.delegate = self
        
        selectorFilter.setContent(dataSource: data3, selectedValues: data4, isMultiselect: multiselecr, minSelection: 1, maxSelection: 10)
        
        selectorFilter.setButtonThemeColor(color: buttonThemeColor)
        selectorFilter.setContentTextColor(Title: tablePriText, subTitle: tableSubText)
        
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
        
        present(selectorFilter, animated: true, completion: nil)
        
    }
    
    
    @IBAction func popSelector(_ sender: Any) {
        openAlert(sender: sender)
    }
    
    @IBAction func showSelector(_ sender: Any) {
        let selectorFilter = InnoSelector.bottomSheet()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:titleTextColor]

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
        
        selectorFilter.hideTopBar = true
        selectorFilter.setFullScreen = setFullScreen
        selectorFilter.selectorViewHeight = 300.0
        selectorFilter.setTitle(title: titleString, color: titleTextColor) // Set Title Attributes
        selectorFilter.setButtonThemeColor(color: buttonThemeColor)
        selectorFilter.setContent(dataSource: data3, selectedValues: data4, isMultiselect: multiselecr, minSelection: 1, maxSelection: 10)
        selectorFilter.setContentTextColor(Title: tablePriText, subTitle: tableSubText)
        
        if pushView {
            selectorFilter.push(viewController: self, innoSelector: selectorFilter)
        }else{
            selectorFilter.presentIn(viewController: self)
        }
    }
    
    @objc func performTask() -> Void {
        let selectorFilter = InnoSelector.navigationDropDown()
        selectorFilter.setContent(dataSource: data3, selectedValues: data4, isMultiselect: false, minSelection: 1, maxSelection: 1)
        
        selectorFilter.setContentTextColor(Title: tablePriText, subTitle: tableSubText)
        
        selectorFilter.completionHandler = { event, selectedValues in
            switch event {
            case .didApply:
                if let selectedData = selectedValues as? [InnoData]{
                    self.data2 = selectedData
                }else{
                    self.data4 = selectedValues as! [String]
                }
                print(selectedValues)
            case .didCancel:
                print("Cancel")
            }
        }
        
        selectorFilter.showSettings()

    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        titleText.resignFirstResponder()
        return true
    }
    
}
