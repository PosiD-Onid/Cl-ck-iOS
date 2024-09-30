//
//  UIApplication.swift
//  Cl!ck
//
//  Created by 이다경 on 9/4/24.
//

import UIKit

extension UIApplication {
    func endEditing() {
        windows.first?.endEditing(true)
    }
}
