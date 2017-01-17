//
//  TraditionalRecipeViewController.swift
//  Chefty
//
//  Created by Jacqueline Minneman on 11/16/16.
//  Copyright © 2016 com.AppRising.SML. All rights reserved.
//

import UIKit

class TraditionalRecipeViewController: UIViewController {
    
    var traditionalRecipeView: TraditionalRecipeView!
    var recipe: Recipe?
    var addToMenuButton = UIBarButtonItem()
    var removeFromMenuButton = UIBarButtonItem()
    var cameFromVC = String()
    let labelFont: UIFont = UIFont(name: Constants.appFont.regular.rawValue, size: CGFloat(Constants.fontSize.xsmall.rawValue))!
    var isSelected = false
    var store = DataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadInputViews()
        
        self.traditionalRecipeView.recipe = self.recipe
        
        // set up the nav bar
        let attributesNormal = [ NSFontAttributeName : labelFont ]
        
        // add the select recipe button to the nav bar
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItems = [backButton]
        
        // set color and font size of nav bar buttons
        backButton.setTitleTextAttributes(attributesNormal, for: .normal)
        
        // add to menu button
        self.addToMenuButton = UIBarButtonItem(title: "Add to Menu", style: .plain, target: self, action: #selector(self.onClickAddAction))
        self.addToMenuButton.setTitleTextAttributes(attributesNormal, for: .normal)
        
        // remove from menu button
        self.removeFromMenuButton = UIBarButtonItem(title: "Take off Menu", style: .plain, target: self, action: #selector(self.onClickDeleteAction))
        self.removeFromMenuButton.setTitleTextAttributes(attributesNormal, for: .normal)
        
        // set the add/remove button
        if let recipe = recipe {
            if store.recipesSelected.contains(recipe) {
                navigationItem.rightBarButtonItem = self.removeFromMenuButton
            } else {
                navigationItem.rightBarButtonItem = self.addToMenuButton
            }
        }
        
        // set style on title
        let color = UIColor(red: 0.875, green: 0.855, blue: 0.773, alpha: 1.000)
        let textStyle = NSMutableParagraphStyle()
        let textFontAttributes = [NSFontAttributeName: UIFont(name: Constants.appFont.bold.rawValue, size: Constants.fontSize.large.rawValue)!, NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: textStyle]
        self.navigationController?.navigationBar.titleTextAttributes = textFontAttributes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Recipe"
        
        let attributesNormal = [ NSFontAttributeName : labelFont ]
        navigationItem.backBarButtonItem?.setTitleTextAttributes(attributesNormal, for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView(){
        if let recipe = recipe {
            self.traditionalRecipeView = TraditionalRecipeView(frame: CGRect.zero, recipe: recipe)
            self.view = self.traditionalRecipeView
        }
    }
    
    func onClickDeleteAction() {
        if let recipe = recipe {
            store.setRecipeUnselected(recipe: recipe)
            navigationItem.rightBarButtonItem = self.addToMenuButton
        }
    }
    
    func onClickAddAction() {
        if let recipe = recipe {
            store.setRecipeSelected(recipe: recipe)
            navigationItem.rightBarButtonItem = self.removeFromMenuButton
        }
    }
    
    func goBack(){
        // people can arrive at this page from the Dinner Menu page and the My Menu page, so we need to send them back to the right one.
  
        if self.cameFromVC == "main" {
            let finalMainControllerInst = FinalMainViewController()
            navigationController?.pushViewController(finalMainControllerInst, animated: true) // show destination with nav bar
        } else {
            let myMenuViewControllerInst = MyMenuViewController()
            navigationController?.pushViewController(myMenuViewControllerInst, animated: true) // show destination with nav bar
        }
        
    }
}

