//
//  MyMenuTableViewCell.swift
//  Chefty
//
//  Created by Paul Tangen on 11/19/16.
//  Copyright © 2016 com.AppRising.SML. All rights reserved.
//

import UIKit

protocol MyMenuTableViewCellDelegate: class {
    func updateTableViewNow()
    func servingTimeFieldSelected(_ sender: UITextField)
    func onClickClearAllRecipes()
}

class MyMenuTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var store = DataStore.sharedInstance
    weak var delegate: MyMenuTableViewCellDelegate?
    var gradientView = GradientView()
    var gradientViewLeftToRight = GradientViewLeftToRight()
    var recipeDescField:UITextField = UITextField()
    var imageViewInst:UIImageView = UIImageView()
    let deleteButton: UIButton = UIButton(type: .roundedRect)

    override func awakeFromNib() { super.awakeFromNib() }

    override func setSelected(_ selected: Bool, animated: Bool) { super.setSelected(selected, animated: animated) }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // background image
        contentView.addSubview(imageViewInst)
        imageViewInst.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageViewInst.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        imageViewInst.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        imageViewInst.translatesAutoresizingMaskIntoConstraints = false
        
        //layout GradientView
        gradientView = GradientView(frame: imageViewInst.frame)
        gradientView.layer.masksToBounds = true
        self.contentView.addSubview(gradientView)
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        gradientView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        gradientView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        gradientView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        gradientViewLeftToRight = GradientViewLeftToRight(frame: imageViewInst.frame)
        gradientViewLeftToRight.layer.masksToBounds = true
        self.contentView.addSubview(gradientViewLeftToRight)
        gradientViewLeftToRight.translatesAutoresizingMaskIntoConstraints = false
        gradientViewLeftToRight.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        gradientViewLeftToRight.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        gradientViewLeftToRight.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        gradientViewLeftToRight.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        // recipeDesc label
        self.recipeDescField.textColor = UIColor.white
        self.recipeDescField.isUserInteractionEnabled = false
        self.recipeDescField.font = UIFont(name: Constants.appFont.light.rawValue, size: 30)
        contentView.addSubview(self.recipeDescField)
        self.recipeDescField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        self.recipeDescField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        self.recipeDescField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.recipeDescField.translatesAutoresizingMaskIntoConstraints = false
        
        // delete button
        let deleteButton: UIButton = UIButton(type: .roundedRect)
        deleteButton.setTitle(Constants.iconLibrary.close.rawValue, for: .normal)
        deleteButton.titleLabel!.font =  UIFont(name: Constants.iconFont.material.rawValue, size: CGFloat(Constants.iconSize.xsmall.rawValue))
        deleteButton.setTitleColor(UIColor(named: .white), for: .normal)
        deleteButton.addTarget(self, action: #selector(MyMenuTableViewCell.onClickDeleteAction), for: UIControlEvents.touchUpInside)
        contentView.addSubview(deleteButton)
        deleteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: -1).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -1).isActive = true
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // should begin editing textfield delegate method
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.delegate?.servingTimeFieldSelected(textField)
        return false // prevents field from being editable
    }
    
    func onClickDeleteAction() {
        if let currentRowString = self.deleteButton.accessibilityLabel {
            if let currentRow = Int(currentRowString) {
                if self.store.recipesSelected.count == 1 { // only one recipe left, treat same as clear all
                    self.delegate?.onClickClearAllRecipes()
                } else {
                    self.store.setRecipeUnselected(recipe: self.store.recipesSelected[currentRow])
                    self.delegate?.updateTableViewNow()
                }
            }
        }
    }
}
