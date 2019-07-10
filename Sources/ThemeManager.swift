//
//  ThemeManager.swift
//  JXTheme
//
//  Created by jiaxin on 2019/7/10.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

public class ThemeManager {
    public static let shared = ThemeManager()
    public private(set) var currentThemeStyle: ThemeStyle = .light
    public var isFollowSystem: Bool = false {
        didSet {
            
        }
    }
    lazy var viewsHashTable: NSHashTable<AnyObject> = {
        return NSHashTable<AnyObject>.init(options: .weakMemory)
    }()
    //TODO:userdefaults存储themestyle
    public func themeStyleDidChange(_ style: ThemeStyle) {
        currentThemeStyle = style
        DispatchQueue.main.async {
            self.viewsHashTable.allObjects.forEach { (object) in
                //让object根据最新的style刷新
                //告知内部和外部最新的style
                if let view = object as? UIView, view.dynamicBackgroundColor != nil {
                    view.backgroundColor = view.dynamicBackgroundColor?(self.currentThemeStyle)
                }
                if let label = object as? UILabel, label.dynamicTextColor != nil {
                    label.textColor = label.dynamicTextColor?(self.currentThemeStyle)
                }
                if let textField = object as? UITextField, textField.dynamicTextColor != nil {
                    textField.textColor = textField.dynamicTextColor?(self.currentThemeStyle)
                }
                if let textView = object as? UITextView, textView.dynamicTextColor != nil {
                    textView.textColor = textView.dynamicTextColor?(self.currentThemeStyle)
                }
                if let imageView = object as? UIImageView, imageView.dynamicImage != nil {
                    imageView.image = imageView.dynamicImage?(self.currentThemeStyle)
                }
                if let layer = object as? CALayer, layer.dynamicBackgroundColor != nil {
                    CATransaction.begin()
                    CATransaction.setDisableActions(true)
                    layer.backgroundColor = layer.dynamicBackgroundColor?(self.currentThemeStyle).cgColor
                    CATransaction.commit()
                }
                if let customizable = object as? ThemeCustomizable {
                    customizable.themeCustomization?(self.currentThemeStyle)
                }
            }
        }
    }
}
