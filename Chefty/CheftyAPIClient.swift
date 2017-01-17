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
                        let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as? [[String: String]]
                        if let responseJSON = responseJSON {
                            for recipeDict in responseJSON {
                                // unwrap the incoming data and create recipes in core data
                                if let unwrappedDisplayName = recipeDict["displayName"],
                                    let unwrappedRecipeID = recipeDict["id"],
                                    let unwrappedImageURL = recipeDict["imageURL"],
                                    let unwrappedImageURLSmall = recipeDict["imageURLSmall"],
                                    let unwrappedServings = recipeDict["servings"],
                                    let unwrappedRecipeType = recipeDict["type"],
                                    let unwrappedSortValue = recipeDict["sortValue"] {
                            
                                    self.createRecipe(displayName: unwrappedDisplayName, recipeID: unwrappedRecipeID, imageURL: unwrappedImageURL, imageURLSmall: unwrappedImageURLSmall, servings: unwrappedServings, type: unwrappedRecipeType, sortValue: unwrappedSortValue)
                                }
                            }
                        }
                        store.populateHomeArrays()
                        completion()
                    } catch {
                        print("An error occured when creating responseJSON")
                    }
                }
            }
            task.resume()
        }
    }
    
    class func createRecipe(displayName: String, recipeID: String, imageURL: String, imageURLSmall: String, servings: String, type: String, sortValue: String) {
        
        let store = DataStore.sharedInstance
        
        // create the core data object
        let context = store.persistentContainer.viewContext
        let recipeInst = NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: context) as? Recipe
        
        // set the properties
        if let recipeInst = recipeInst {
            recipeInst.displayName = displayName
            recipeInst.id = recipeID
            recipeInst.imageURL = imageURL
            recipeInst.imageURLSmall = imageURLSmall
            recipeInst.servings = servings
            recipeInst.type = type
            recipeInst.servingTime = self.getServingTime() as NSDate?
            if let sortValue16 = Int16(sortValue) {
                recipeInst.sortValue = sortValue16
            }
        
            // add new recipe to dataStore/coredata
            store.recipes.append(recipeInst)
            store.saveRecipesContext()
            store.getRecipesFromCoreData()
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
        if let compServingTime = calendarInst.date(from: componentsServingTime) {
            return compServingTime
        }
        return Date() // should never happen
    }

    class func getStepsAndIngredients(recipe: Recipe, completion: @escaping () -> Void){
        let store = DataStore.sharedInstance
        if let recipeID = recipe.id {
            let urlString = "\(Secrets.cheftyAPIURL)/getRecipeSteps.php?key=\(Secrets.cheftyKey)&recipe=\(recipeID)"
            let url = URL(string: urlString)
            var recipeRequested:Recipe?
            let context = store.persistentContainer.viewContext
            recipeRequested = recipe
            
            if let recipeRequestedUnwrapped = recipeRequested {
                if let recipeStepsEmptyBeforeAPIRequest = recipeRequestedUnwrapped.steps?.allObjects.isEmpty {
                    // fetch steps if needed
                    if recipeStepsEmptyBeforeAPIRequest {
                        if let unwrappedUrl = url{
                            let session = URLSession.shared
                            let task = session.dataTask(with: unwrappedUrl) { (data, response, error) in
                                if let unwrappedData = data {
                                    do {
                                        let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as? [[String: Any]]
                                        
                                        if let responseJSON = responseJSON {
                                            for stepsDict in responseJSON {
                                                let recipeIdFromStep = stepsDict["recipe"] as? String
                                                // if the step is related to the recipeRequested, get the steps and add them to the recipe in CD
                                                if recipeRequested?.id == recipeIdFromStep {
                                                    
                                                    let newStep: Step = Step(context: context)
                                                    
                                                    if let stepTitleUnwrapped = stepsDict["stepTitle"] as? String {
                                                        newStep.stepTitle = stepTitleUnwrapped   // getting STEP TITLES
                                                    }
                                                    
                                                    if let procedureUnwrapped = stepsDict["procedure"] as? String {
                                                        newStep.procedure = procedureUnwrapped  // getting STEP PROCEDURE
                                                    }
                                                    
                                                    if let fullAttentionRequiredUnwrapped = stepsDict["fullAttentionRequired"] as? String {
                                                        if let fullAttentionRequiredUnwrappedBool = Bool(fullAttentionRequiredUnwrapped) {
                                                            newStep.fullAttentionRequired = fullAttentionRequiredUnwrappedBool  // getting FULL ATTENTION
                                                        }
                                                    }
                                                    
                                                    if let stepNumberUnwrapped = stepsDict["step"] {
                                                        
                                                        let stepNumberInt = stepNumberUnwrapped as? Int
                                                        let stepNumberString = stepNumberUnwrapped as? String
                                                        
                                                        if let numberInt = stepNumberInt {
                                                            newStep.stepNumber = Int32(numberInt) // getting STEP NUMBER
                                                        }
                                                        
                                                        if let numberString = stepNumberString {
                                                            if let numberString32 = Int32(numberString) {
                                                                newStep.stepNumber = numberString32 // getting STEP NUMBER
                                                            }
                                                        }
                                                    }
                                                    
                                                    let durationString = stepsDict["duration"] as? String
                                                    guard let unwrappedDuration = durationString else { return }
                                                    let durationInt = unwrappedDuration.convertDurationToMinutes()
                                                    newStep.duration = Int32(durationInt)   // getting DURATION
                                                    
                                                    let timeToStartString = stepsDict["timeToStart"] as? String
                                                    guard let unwrappedTimeToStart = timeToStartString else { return }
                                                    let timeToStartInt = unwrappedTimeToStart.convertTimeToStartToMinutes()
                                                    newStep.timeToStart = Int32(timeToStartInt) // getting TIME TO START
                                                    
                                                    recipeRequested?.addToSteps(newStep)  // add step to recipe
                                                    
                                                    // add ingredients to the step
                                                    
                                                    // get the value, could be empty
                                                    if let ingredientsRawUnwrapped = stepsDict["ingredients"] {
                                                        // convert results from JSON into a [string]
                                                        let ingredientsStringArray = ingredientsRawUnwrapped as? [String]
                                                        if let ingredientsStringArray = ingredientsStringArray {
                                                            if ingredientsStringArray.isEmpty == false {
                                                                for ingredient in ingredientsStringArray {
                                                                    let newIngredient: Ingredient = Ingredient(context: context)
                                                                    newIngredient.isChecked = false   // setting default value for isChecked
                                                                    newIngredient.ingredientDescription = ingredient  // getting ingredientDescription
                                                                    newStep.addToIngredients(newIngredient)
                                                                }
                                                            } else {
                                                                //print("We DO NOT have ingredient for this step.")
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        completion()
                                    } catch {
                                        print("An error occured when creating responseJSON")
                                    }
                                    store.saveRecipesContext()
                                }
                            }
                            task.resume()
                        }
                    } else {
                        completion()
                    }
                }
            }
        }
    }
}
