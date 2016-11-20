//
//  MyMenuView.swift
//  Chefty
//
//  Created by Paul Tangen on 11/16/16.
//  Copyright © 2016 com.AppRising.SML. All rights reserved.
//

import UIKit

class MyMenuView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var sampleValue = String()
    var recipesSelected = [Recipe]()
    var recipeNamesTemp = String()
    var store = DataStore.sharedInstance
    
    override init(frame:CGRect){
        super.init(frame: frame)
        


        
        // set some recipes as selected, this will happen in the revious screen soon
        for recipe in store.recipes {
            if recipe.id == "apple-pie"{ recipe.selected = true }
            if recipe.id == "chicken-breasts"{ recipe.selected = true }
            if recipe.id == "black-bean-couscous-salad"{ recipe.selected = true }
            if recipe.id == "yummy-baked-potato-skins"{ recipe.selected = true }
        }

        // get selected recipes
        for recipe in store.recipes {
            if recipe.selected == true {
                recipesSelected.append(recipe)
                // create the temp string
                if self.recipeNamesTemp == "" {
                    self.recipeNamesTemp = recipe.displayName
                } else {
                    self.recipeNamesTemp.append(", " + recipe.displayName)
                }
            }
        }
        
        // get an image for a recipe and adds it to the view
//        let imageView1 = UIImageView(frame: CGRect(x:0, y:0, width:200, height:200))
//        Recipe.getImage(recipe: recipesSelected[0], imageView: imageView1, view: self) // gets image data and adds the imageView to the view
//        imageView1.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = UIColor.white
        
        //initialize
        let deleteApp: UIButton = UIButton(type: .roundedRect)
        let selectedRecipesTextField: UITextView = UITextView()
        
        // configure controls
        selectedRecipesTextField.text = recipeNamesTemp
        selectedRecipesTextField.backgroundColor = UIColor.white
        print("recipeNamesTemp: \(recipeNamesTemp)")
        
        // add the button
        self.addSubview(deleteApp)
        self.addSubview(selectedRecipesTextField)
        
        // constrain the button
        deleteApp.topAnchor.constraint(equalTo: self.topAnchor, constant: 100).isActive = true
        deleteApp.translatesAutoresizingMaskIntoConstraints = false
        
        selectedRecipesTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 200).isActive = true
        selectedRecipesTextField.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        selectedRecipesTextField.heightAnchor.constraint(equalToConstant: 100).isActive = true
        selectedRecipesTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height - 200
        let screenWidth = screenSize.width
        
        // add the tableview
        let tableView = UITableView(frame: (CGRect(x: 0, y: 300, width: screenWidth, height: screenHeight-200)), style: UITableViewStyle.grouped)
        self.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesSelected.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // set the custom cell
        let cell = MyMenuTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "prototypeCell")
        cell.myLabel1.text = recipesSelected[indexPath.row].displayName
        cell.myLabel2.text = "\(indexPath.row)"
        Recipe.getImage(recipe: recipesSelected[0], imageView: cell.imageView1, view: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
