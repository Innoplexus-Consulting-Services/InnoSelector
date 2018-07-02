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

public class InnoData: NSObject, Comparable {
    
    var image : UIImage? = nil
    var mainText : String = ""
    var subText : String? = nil
    
    public override init() {
    }
    
    public init(image: UIImage?, mainText: String, subText:String?) {
        self.image = image
        self.mainText = mainText
        self.subText = subText
    }
    
    public static func == (lhs: InnoData, rhs: InnoData) -> Bool {
        return lhs.image == rhs.image && lhs.mainText == rhs.mainText && lhs.subText == rhs.subText
    }
    
    public static func < (lhs: InnoData, rhs: InnoData) -> Bool {

        return lhs.mainText < rhs.mainText && lhs.subText! < rhs.subText!
        
    }
    
    static public func > (lhs: InnoData, rhs: InnoData) -> Bool {
            return lhs.mainText > rhs.mainText && lhs.subText! > rhs.subText!
    }
}


class InnoSelectorCustomCellViewModel: NSObject{
    
    //MARK: Properties
    
    var isMultiselect = false
    var selectedValuesCustom = [InnoData]()
    var selectedValues = [String]()
    var dataSourceCustom = [InnoData]()
    var dataSource = [String]()
    var minSelection = 1
    var maxSelection = 10
    
    //MARK: Methods
    
    override init() {
        
    }
    
    init(dataSource:[InnoData], selectedValues:[InnoData] = [], isMultiselect:Bool = false, minSelection:Int = 1, maxSelection:Int = 100) {
        self.dataSourceCustom = dataSource
        self.selectedValuesCustom = selectedValues
        self.isMultiselect = isMultiselect
        self.minSelection = minSelection
        self.maxSelection = maxSelection
    }
    
    init(dataSource:[String], selectedValues:[String] = [], isMultiselect:Bool = false, minSelection:Int = 1, maxSelection:Int = 100) {
        self.dataSource = dataSource
        self.selectedValues = selectedValues
        self.isMultiselect = isMultiselect
        self.minSelection = minSelection
        self.maxSelection = maxSelection
    }
}
