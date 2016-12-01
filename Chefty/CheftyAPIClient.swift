//
//  CheftyAPIClient.swift
//  Chefty
//
//  Created by Paul Tangen on 11/17/16.
//  Copyright © 2016 com.AppRising.SML. All rights reserved.
//

import Foundation
import UIKit
import CoreData



class CheftyAPIClient {
    
    class func getRecipiesFromDB(completion: @escaping () -> Void) {
        let store = DataStore.sharedInstance
        let urlString = "\(Secrets.cheftyAPIURL)/getRecipes.php?key=\(Secrets.cheftyKey)"
        let url = URL(string: urlString)
        
        if let unwrappedUrl = url{
            let session = URLSession.shared
            let task = session.dataTask(with: unwrappedUrl) { (data, response, error) in
                if let unwrappedData = data {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as! [[String: String]]
                        
                        for recipeDict in responseJSON {
                            let context = store.persistentContainer.viewContext
                            let recipeInst = NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: context) as! Recipe
                            
                            if let unwrappedDisplayName = recipeDict["displayName"] {
                                recipeInst.displayName =  unwrappedDisplayName as String
                            }
                            
                            if let unwrappedRecipeID = recipeDict["id"] {
                                recipeInst.id = unwrappedRecipeID as String
                            }
                            
                            if let unwrappedImageURL = recipeDict["imageURL"] {
                                recipeInst.imageURL = unwrappedImageURL as String
                            }
                            
                            if let unwrappedServings = recipeDict["servings"] {
                                recipeInst.servings = unwrappedServings as String
                            }
                            
                            if let unwrappedRecipeType = recipeDict["type"] {
                                recipeInst.type = unwrappedRecipeType as String
                            }
                            
                            recipeInst.servingTime = self.getServingTime() as NSDate?
                            
                            if let unwrappedSortValue = recipeDict["sortValue"] {
                                let sortValueString = unwrappedSortValue as String
                                recipeInst.sortValue = Int16(sortValueString)!
                            }
                            
                            
                            if recipeInst.id == "apple-pie" || recipeInst.id == "yummy-baked-potato-skins" || recipeInst.id == "chicken-breasts" || recipeInst.id == "black-bean-couscous-salad" {
                                recipeInst.selected = true as Bool
                            } else {
                                recipeInst.selected = false as Bool
                            }
                            
                            store.recipes.append(recipeInst)
                            
                            store.saveRecipesContext()
                            store.getRecipesFromCoreData()
                        }
                        completion()
                        
                    } catch {
                        print("An error occured when creating responseJSON")
                    }
                }
            }
            task.resume()
        }
    }
    
    //    class func getRecipeSteps(with completion: @escaping ()-> Void) {
    //        let store = DataStore.sharedInstance
    //        //TODO: change recipeID to handle all selected recipes
    //        let recipeID = "marinated-cheese-appetizer"
    //        //let urlString = "\(Secrets.cheftyAPIURL)/getRecipeSteps.php?key=\(Secrets.cheftyKey)=\(recipeID)"
    //        let urlString = "http://api.ptangen.com/getRecipeSteps.php?key=flatiron0916&recipe=marinated-cheese-appetizer"
    //        let url = URL(string: urlString)
    //
    //        if let unwrappedUrl = url{
    //            let session = URLSession.shared
    //            let task = session.dataTask(with: unwrappedUrl) { (data, response, error) in
    //                if let unwrappedData = data {
    //                    do {
    //                        let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as! [[String:Any]]
    //
    //                        for stepDict in responseJSON {
    //                            let step = RecipeStep(dict: stepDict)
    //                            store.recipeSteps.append(step)
    //                        }
    //
    //                        completion()
    //                    } catch {
    //                        print("An error occured when creating responseJSON")
    //                    }
    //                }
    //            }
    //            task.resume()
    //        }
    //    }
    
    class func getRecipeSteps1(with completion: @escaping ()-> Void) {
        let store = DataStore.sharedInstance
        //TODO: change recipeID to handle all selected recipes
        let recipeID = "marinated-cheese-appetizer"
        //let urlString = "\(Secrets.cheftyAPIURL)/getRecipeSteps.php?key=\(Secrets.cheftyKey)=\(recipeID)"
        let urlString = "http://api.ptangen.com/getRecipeSteps.php?key=flatiron0916&recipe=marinated-cheese-appetizer"
        let url = URL(string: urlString)
        
        if let unwrappedUrl = url{
            let session = URLSession.shared
            let task = session.dataTask(with: unwrappedUrl) { (data, response, error) in
                if let unwrappedData = data {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as! [[String:Any]]
                        
                        for stepDict in responseJSON {
                            let step = RecipeStep(dict: stepDict)
                            store.recipeSteps.append(step)
                        }
                        
                        completion()
                    } catch {
                        print("An error occured when creating responseJSON")
                    }
                }
            }
            task.resume()
        }
    }
    
    class func getRecipeSteps2 (with completion: @escaping ()-> Void) {
        let store = DataStore.sharedInstance
        //TODO: change recipeID to handle all selected recipes
        let recipeID = "authentic-italian-meatballs"
        //let urlString = "\(Secrets.cheftyAPIURL)/getRecipeSteps.php?key=\(Secrets.cheftyKey)=\(recipeID)"
        let urlString = "http://api.ptangen.com/getRecipeSteps.php?key=flatiron0916&recipe=authentic-italian-meatballs"
        let url = URL(string: urlString)
        
        if let unwrappedUrl = url{
            let session = URLSession.shared
            let task = session.dataTask(with: unwrappedUrl) { (data, response, error) in
                if let unwrappedData = data {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as! [[String:Any]]
                        
                        for stepDict in responseJSON {
                            let step = RecipeStep(dict: stepDict)
                            store.recipeSteps.append(step)
                        }
                        
                        completion()
                    } catch {
                        print("An error occured when creating responseJSON")
                    }
                }
            }
            task.resume()
        }

    }
    
    class func getServingTime () -> Date {
        let calendarInst = Calendar(identifier: .gregorian)
        var componentsServingTime = DateComponents()
        componentsServingTime.year = calendarInst.component(.year, from: Date())
        componentsServingTime.month = calendarInst.component(.month, from: Date())
        componentsServingTime.day = calendarInst.component(.day, from: Date())
        componentsServingTime.hour = 19
        componentsServingTime.minute = 00
        componentsServingTime.second = 00
        let servingTime = calendarInst.date(from: componentsServingTime)!
        return servingTime
    }
    
    
    class func getIngredients(completion: @escaping () -> Void){
        
        let store = DataStore.sharedInstance
        let urlString = "\(Secrets.cheftyAPIURL)/getIngredients.php?key=\(Secrets.cheftyKey)&recipe1=chicken-breasts&recipe2=sweet-potato-fries&recipe3=peach-cobbler&recipe4=beef-broccoli-stir-fry"
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let unwrappedData = data {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as! [[String: String]]
                    
                    for ingredientDict in responseJSON {
                        let context = store.persistentContainer.viewContext
                        let ingredientInst = Ingredient(context: context)
                        ingredientInst.recipeID = ingredientDict["recipeID"] as String!
                        print(ingredientInst.recipeID!)
                        ingredientInst.recipeDescription = ingredientDict["description"] as String!
                        print(ingredientInst.recipeDescription!)
                        ingredientInst.isChecked = false
                        
                        
                        for recipe in store.recipes {
                            if recipe.id == ingredientInst.recipeID {
                                //                                recipe.addToIngredient(ingredientInst)
                            }
                        }
                        
                        
                        
                        store.saveRecipesContext()
                    }
                    completion()
                } catch {
                    print("An error occured when creating responseJSON")
                }
            }
        }
        task.resume()
        
        
    }
    
    
    class func getStepsAndIngredients(recipeIDRequest: String, completion: @escaping () -> Void){
        let store = DataStore.sharedInstance
        let urlString = "\(Secrets.cheftyAPIURL)/getRecipeSteps.php?key=\(Secrets.cheftyKey)&recipe=\(recipeIDRequest)"
        let url = URL(string: urlString)
        var selectedRecipe:Recipe?
        
        // get the recipe with the id that was requested
        
        
        if let unwrappedUrl = url{
            let session = URLSession.shared
            let task = session.dataTask(with: unwrappedUrl) { (data, response, error) in
                if let unwrappedData = data {
                    do {
                        
                        let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as! [[String: Any]]
                        //print(responseJSON)
                        
                        for stepsDict in responseJSON {
                            var recipeIdFromStep = stepsDict["recipe"]
                            
                            
                            if recipeIDRequest == recipeIdFromStep as! String {
                                print("recipeIDRequest: \(recipeIDRequest) = recipeIdFromStep \(recipeIdFromStep)")
                                //store.saveRecipeSelectedContext()
                            }
                        }
                        //completion()
                        
                    } catch {
                        print("An error occured when creating responseJSON")
                    }
                }
            }
            task.resume()
        }
    }
    
    

    class func fetchImage(_ url: URL, recipe: Recipe, completion: @escaping () -> Void) {
        let store = DataStore.sharedInstance
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard let imageData = try? Data(contentsOf: url) else { fatalError() }
            let image = UIImage(data: imageData)
            store.images.append(image!)
            OperationQueue.main.addOperation {
                completion()
            }
        }
        task.resume()
    }
    
    
    
}