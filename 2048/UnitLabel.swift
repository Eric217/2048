//
//  UnitLabel.swift
//  2048
//
//  Created by Eric on 2019/12/16.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit
 
class UnitLabel: UILabel {
    
    private static let colorProvider: ColorProviderProtocol = ColorProvider()
    
    var value: Int = 0 {
        didSet {
            if self.value == 0 {
                self.text = nil
            } else {
                self.backgroundColor = UnitLabel.colorProvider.backColor(self.value)
                self.textColor = UnitLabel.colorProvider.numberColor(self.value)
                self.text = "\(self.value)"
             
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textAlignment = .center
        self.layer.masksToBounds = true
     
        self.font = UIFont(name: "HelveticaNeue-Bold", size: UIFont.preferredFont(forTextStyle: .largeTitle).fontDescriptor.pointSize)
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.3 // default size for that text style is 34
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
