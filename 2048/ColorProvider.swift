//
//  ColorProvider.swift
//  2048
//
//  Created by Eric on 2019/12/14.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit

protocol ColorProviderProtocol {
    func backColor(_ value: Int) -> UIColor
    func numberColor(_ value: Int) -> UIColor
}

class ColorProvider: ColorProviderProtocol {
 
    func numberColor(_ value: Int) -> UIColor {
        if value == 4 || value == 2 {
            return UIColor(red:0.4, green:110/255.0, blue:100/255.0, alpha:1.0)
        }
        return UIColor.white
    }
    
    func backColor(_ value: Int) -> UIColor {
        switch value {
        case 2:
            return UIColor(red:238.0/255.0, green:228.0/255.0, blue:218.0/255.0, alpha:1.0)
        case 4:
            return UIColor(red:237.0/255.0, green:224.0/255.0, blue:200.0/255.0, alpha:1.0)
        case 8:
            return UIColor(red:242.0/255.0, green:177.0/255.0, blue:121.0/255.0, alpha:1.0)
        case 16:
            return UIColor(red:245.0/255.0, green:149.0/255.0, blue:99.0/255.0, alpha:1.0)
        case 32:
            return UIColor(red:246.0/255.0, green:124.0/255.0, blue:95.0/255.0, alpha:1.0)
        case 64, 128, 256:
            return UIColor(red:246.0/255.0, green:94.0/255.0, blue:59.0/255.0, alpha:1.0)
        case 512, 1024:
            return UIColor(red:0.93, green:0.81, blue:0.447, alpha:1.0)
        case 2048:
            return UIColor(red:0.95, green:0.23, blue:0.24, alpha:1.0)
        default:
            return UIColor.black
        }
        // case 4096, 8192:
        //   return UIColor(red:0.96, green:0.2, blue:0.2, alpha:1.0)
    }

}
