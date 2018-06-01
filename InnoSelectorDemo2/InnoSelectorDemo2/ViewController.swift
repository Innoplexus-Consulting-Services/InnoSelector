//
//  ViewController.swift
//  InnoSelectorDemo2
//
//  Created by gopinath.a on 29/05/18.
//  Copyright © 2018 Innoplexus. All rights reserved.
//

import UIKit
import InnoSelector

class ViewController: UIViewController{
    
    var data: [CustomDataObject] = []
    var data2: [CustomDataObject] = []
    var multiselecr: Bool = true
    var pushView: Bool = false

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
    
    var titleTextColor = UIColor.blue
    var tablePriText = UIColor.blue
    var tableSubText = UIColor.blue
    var buttonThemeColor = UIColor.blue
    
    var titleString = "SELECTOR"
    var setFullScreen:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.title = "InnoSelector"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:titleTextColor]
        setConerRadius()
        
        data =  [CustomDataObject(image: #imageLiteral(resourceName: "far_cry_3_beach_game_graphics_hdr_95932_1920x1080"), primaryText: "Farcry 3", subText: "Ubisoft"), CustomDataObject(image: nil, primaryText: "Content without Image", subText: "InnoSelector"), CustomDataObject(image: #imageLiteral(resourceName: "far_cry_primal_action_adventure_ubisoft_montreal_106127_1920x1190"), primaryText: "Farcry Primal", subText: "Ubisoft"),CustomDataObject(image: #imageLiteral(resourceName: "tomb_raider_definitive_edition_crystal_dynamics_lara_croft_93180_2880x1800"), primaryText: "Tomb Raider", subText: "Square Enix"),CustomDataObject(image: nil, primaryText: "Content without Image and SubText", subText: nil)]
        
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
    
    @IBAction func showSelector(_ sender: Any) {
        let selectorFilter = InnoSelectorViewController.instantiate()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:titleTextColor]
        titleString = titleText.text!
        
        selectorFilter.completionHandler = { event, selectedValues in
            switch event {
            case .didApply:
                self.data2 = selectedValues
                print(selectedValues.count)
            case .didCancel:
                print("Cancel")
            }
        }
        
        selectorFilter.setFullScreen = setFullScreen
        selectorFilter.selectorViewHeightConstant = 300.0
        selectorFilter.setTitle(title: titleString, color: titleTextColor) // Set Title Attributes
        selectorFilter.setButtonThemeColor(color: buttonThemeColor)
        selectorFilter.setTableContent(dataSource: data, selectedValues: data2, isMultiselect: multiselecr, minSelection: 1, maxSelection: 10)
        selectorFilter.setTableContentTextColor(primaryText: tablePriText, subText: tableSubText)
        
        
        if pushView {
            self.navigationController?.pushViewController(selectorFilter, animated: true)
        }else{
            selectorFilter.modalPresentationStyle = .overCurrentContext
            present(selectorFilter, animated: true, completion: nil)
        }
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
