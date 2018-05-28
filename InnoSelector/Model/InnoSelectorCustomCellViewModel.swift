//
//  InnoSelectorCustomCellViewModel.swift
//  InnoSelector
//
//  Created by gopinath.a on 25/05/18.
//  Copyright © 2018 innoplexus. All rights reserved.
//

import Foundation
import UIKit

/// Button Events
///
/// - didApply: Apply Button Event
/// - didCancel: Cancel Button Event
public enum SelectorFilterEvent {
    case didApply
    case didCancel
}

public class CustomDataObject: NSObject, Comparable {
    
    var image : UIImage? = nil
    var mainText : String = ""
    var subText : String? = nil
    
    public override init() {
    }
    
    public init(image: UIImage?, primaryText: String, subText:String?) {
        self.image = image
        self.mainText = primaryText
        self.subText = subText
    }
    
    public static func == (lhs: CustomDataObject, rhs: CustomDataObject) -> Bool {
        return lhs.image == rhs.image && lhs.mainText == rhs.mainText && lhs.subText == rhs.subText
    }
    
    public static func < (lhs: CustomDataObject, rhs: CustomDataObject) -> Bool {

        return lhs.mainText < rhs.mainText && lhs.subText! < rhs.subText!
        
    }
    
    static public func > (lhs: CustomDataObject, rhs: CustomDataObject) -> Bool {
            return lhs.mainText > rhs.mainText && lhs.subText! > rhs.subText!
    }
}


class InnoSelectorCustomCellViewModel: NSObject{
    
    //MARK: Properties
    
    var isMultiselect = false
    var selectedValues = [CustomDataObject]()
    var dataSource = [CustomDataObject]()
    var minSelection = 1
    var maxSelection = 10
    
    //MARK: Methods
    
    override init() {
        
    }
    
    init(dataSource:[CustomDataObject], selectedValues:[CustomDataObject] = [], isMultiselect:Bool = false, minSelection:Int = 1, maxSelection:Int = 10) {
        self.dataSource = dataSource
        self.selectedValues = selectedValues
        self.isMultiselect = isMultiselect
        self.minSelection = minSelection
        self.maxSelection = maxSelection
    }
}
