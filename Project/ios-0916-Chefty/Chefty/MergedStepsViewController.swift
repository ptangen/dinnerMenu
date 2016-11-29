//
//  MergedSteps.swift
//  Chefty
//
//  Created by Jacqueline Minneman on 11/28/16.
//  Copyright © 2016 com.AppRising.SML. All rights reserved.
//

import Foundation
import UIKit

class MergedStepsViewController: UIViewController {
    
    var mergedStepsView: MergedStepsView!
    var store = DataStore.sharedInstance
    var recipeSteps = [RecipeStep]()
    var stepsForDisplayArray = [Int]()
    var stepTitlesForDisplay = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAPIInfo(){
            print("first recipe step \(self.recipeSteps[0].timeToStart)")
            self.mergeRecipeSteps()
            print("inside ViewDidLoad closure")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool = false) {
        self.title = "Merged Recipe Steps"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView(){
        self.mergedStepsView = MergedStepsView(frame: CGRect.zero)
        self.view = self.mergedStepsView
    }
    
    func getAPIInfo(with completion: @escaping () -> ()) {
        store.getRecipeSteps {
            
            for stepGroup in self.store.recipeSteps {
                self.recipeSteps.append(stepGroup)
            }
            //print(self.recipeSteps.count) --> yes, this correctly grabs all the steps for Apple Pie and stores in recipeSteps
            
            completion()
        }
        
    }
}

extension MergedStepsViewController {
    
    func mergeRecipeSteps() {
        
        //take Apple Pie steps stored in recipeSteps and re-order/merge them
        
        var addedTime = 0
        
        recipeSteps = self.recipeSteps.sorted { (step1: RecipeStep, step2: RecipeStep) -> Bool in
            
            
            //TODO: handle optionals without force unwrapping
            
            //same start
            if step1.timeToStart == step2.timeToStart {
                
                //different attentionNeeded
                if step1.fullAttentionRequired == false && step2.fullAttentionRequired == true {
                    return true
                } else if step1.fullAttentionRequired == true && step2.fullAttentionRequired == false {
                    addedTime += step1.timeToStart! + step1.duration! - step2.timeToStart!
                    print("\(addedTime): step1 = \(step1.timeToStart); step2 = \(step2.timeToStart)")
                    return false
                    
                    //same attentionNeeded, add shorter duration to addedTime
                } else if step1.fullAttentionRequired == step2.fullAttentionRequired {
                    if step1.duration! > step2.duration! {
                        addedTime += step2.duration!
                        print("\(addedTime): step1 = \(step1.timeToStart); step2 = \(step2.timeToStart)")
                        return false
                    } else if step1.duration! < step2.duration! {
                        addedTime += step1.duration!
                        print("\(addedTime): step1 = \(step1.timeToStart); step2 = \(step2.timeToStart)")
                        return true
                    }
                }
            }
            
            //overlap duration
            if (step2.timeToStart! > step1.timeToStart!) && (step2.timeToStart! < (step1.timeToStart! + step1.duration!)) {
                
                if step1.fullAttentionRequired == false && step2.fullAttentionRequired == true {
                    addedTime += step2.timeToStart! - (step1.timeToStart! + step1.duration!)
                    print("\(addedTime): step1 = \(step1.timeToStart); step2 = \(step2.timeToStart)")
                    return true
                    
                } else if step1.fullAttentionRequired == true && step2.fullAttentionRequired == false {
                    addedTime += (step1.timeToStart! + step1.duration!) - step2.timeToStart!
                    print("\(addedTime): step1 = \(step1.timeToStart); step2 = \(step2.timeToStart)")
                    return true
                    
                } else if step1.fullAttentionRequired == step2.fullAttentionRequired {
                    addedTime += (step1.timeToStart! + step1.duration!) - step2.timeToStart!
                    print("\(addedTime): step1 = \(step1.timeToStart); step2 = \(step2.timeToStart)")
                    return true
                }
            }
            
            return step1.timeToStart! < step2.timeToStart!
            
            //return(step1.duration! < step2.duration!)
            
        }
        
        //testcase with duration/timeToStart
//        for step in recipeSteps {
//            stepsForDisplayArray.append(step.timeToStart!)
//        }
//        
//        var stringArray = stepsForDisplayArray.map { "\($0)" }
//        
//        store.recipeProceduresMerged = stringArray.joined(separator: "\n")
        
        
        
        //create array with ordered/merged procedures for display in tableview
        
        for step in recipeSteps {
            stepTitlesForDisplay.append(step.stepTitle!)
        }

        store.recipeProceduresMerged = stepTitlesForDisplay.joined(separator: "\n\n")
        
    }
}
