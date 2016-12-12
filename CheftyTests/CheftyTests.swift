//
//  CheftyTests.swift
//  CheftyTests
//
//  Created by Paul Tangen on 12/9/16.
//  Copyright © 2016 com.AppRising.SML. All rights reserved.
//

import XCTest
import CoreData
@testable import Chefty

class CheftyTests: XCTestCase {
    
    let store = DataStore.sharedInstance
    
    override func setUp() {
        super.setUp()
        
        // create a recipe and put it in core data
        CheftyAPIClient.createRecipe(displayName: "Tuna Sandwich", recipeID: "tuna-sandwich", imageURL: "http://api.ptangen.com/images/sweetPotatoFriesSmall.jpeg", imageURLSmall: "http://api.ptangen.com/images/sweetPotatoFriesSmall.jpeg", servings: "2", type: "main", sortValue: "2")
        

    }
    
    override func tearDown() {
        // This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        for recipeInst in self.store.recipesSelected {
            self.store.setRecipeUnselected(recipe: recipeInst)
        }
    }
    
    func testVerifyRecipeCreation() {
        
        // pull a recipe out of the datastore
        var recipeForTesting: Recipe?
        for recipe in store.recipes {
            recipe.id == "tuna-sandwich" ? recipeForTesting = recipe : ()
        }
        
        // test for the properties
        if let recipeForTesting = recipeForTesting {
            XCTAssert(recipeForTesting.servings == "2")
        }
    }
    
    func testVerifyRecipesSelected() {
        
        // pull a recipe out of the datastore
        var recipeForTesting: Recipe?
        for recipe in store.recipes {
            recipe.id == "tuna-sandwich" ? recipeForTesting = recipe : ()
        }
        
        // set the recipe as selected, add to recipesSelected array
        if let recipeForTesting = recipeForTesting {
            store.setRecipeSelected(recipe: recipeForTesting)
        }
        
        // test for the properties
        if let recipeForTesting = recipeForTesting {
            XCTAssert(recipeForTesting.selected == true)
            XCTAssert(store.recipesSelected.count == 1)
        }
    }
    
}