//
//  MergedSteps.swift
//  Chefty
//
//  Created by Jacqueline Minneman on 11/28/16.
//  Copyright © 2016 com.AppRising.SML. All rights reserved.
//

import Foundation
import UIKit

class MergedStepsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //TODO: add conditional to make sure recipe not already pre-loaded from ingredients
    
    var mergedStepsView: MergedStepsView!
    var store = DataStore.sharedInstance
    var recipeSteps = [Steps]()
    //var stepTitlesForDisplay = [String]()
    var tableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(self.tableView)
        
        getStepsFromRecipesSelected {
            print("4")
            self.mergeRecipeSteps()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeSteps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = recipeSteps[indexPath.row].stepTitle
        return cell
    }
    
    
    
    func getStepsFromRecipesSelected(completion: @escaping () -> ()) {
        
        print("1")
        var intArray = [Int]()
        
        self.recipeSteps.removeAll()
        print("Number of recipes selected - \(store.recipesSelected.count)")
        for (index,singleRecipe) in store.recipesSelected.enumerated() {
            print("\(singleRecipe.displayName) -  Item \(index)")
            DispatchQueue.main.async {
                CheftyAPIClient.getStepsAndIngredients(recipeIDRequest: singleRecipe.id!, completion: {
                    print("6")
                })
            }
            
            let allRecipeSteps = singleRecipe.step!.allObjects as! [Steps]

            for recipe in allRecipeSteps{
                print("\(recipe.stepTitle) - \(recipe.duration)")
            }
            self.recipeSteps += allRecipeSteps
            
        }
        
        print("2")
        
        completion()
        
        print("5")
        
    }
    
}




extension MergedStepsViewController {
    
    func mergeRecipeSteps() {
        print("3")
        
        var addedTime = 0
        
        recipeSteps = self.recipeSteps.sorted { (step1: Steps, step2: Steps) -> Bool in
            //
            //            //TODO: handle optionals without force unwrapping
            //
            //            //same start
            //            if step1.timeToStart == step2.timeToStart {
            //
            //                //different attentionNeeded
            //                if step1.fullAttentionRequired == false && step2.fullAttentionRequired == true {
            //                    return true
            //                } else if step1.fullAttentionRequired == true && step2.fullAttentionRequired == false {
            //                    addedTime += step1.timeToStart! + step1.duration! - step2.timeToStart!
            //                    //print("\(addedTime): step1 = \(step1.timeToStart); step2 = \(step2.timeToStart)")
            //                    return false
            //
            //                    //same attentionNeeded, add shorter duration to addedTime
            //                } else if step1.fullAttentionRequired == step2.fullAttentionRequired {
            //                    if step1.duration! > step2.duration! {
            //                        addedTime += step2.duration!
            //                        //print("\(addedTime): step1 = \(step1.timeToStart); step2 = \(step2.timeToStart)")
            //                        return false
            //                    } else if step1.duration! < step2.duration! {
            //                        addedTime += step1.duration!
            //                        //print("\(addedTime): step1 = \(step1.timeToStart); step2 = \(step2.timeToStart)")
            //                        return true
            //                    }
            //                }
            //            }
            //
            //            //overlap duration
            //            if (step2.timeToStart! > step1.timeToStart!) && (step2.timeToStart! < (step1.timeToStart! + step1.duration!)) {
            //
            //                if step1.fullAttentionRequired == false && step2.fullAttentionRequired == true {
            //                    addedTime += step2.timeToStart! - (step1.timeToStart! + step1.duration!)
            //                    //print("\(addedTime): step1 = \(step1.timeToStart); step2 = \(step2.timeToStart)")
            //                    return true
            //
            //                } else if step1.fullAttentionRequired == true && step2.fullAttentionRequired == false {
            //                    addedTime += (step1.timeToStart! + step1.duration!) - step2.timeToStart!
            //                    //print("\(addedTime): step1 = \(step1.timeToStart); step2 = \(step2.timeToStart)")
            //                    return true
            //
            //                } else if step1.fullAttentionRequired == step2.fullAttentionRequired {
            //                    addedTime += (step1.timeToStart! + step1.duration!) - step2.timeToStart!
            //                    //print("\(addedTime): step1 = \(step1.timeToStart); step2 = \(step2.timeToStart)")
            //                    return true
            //                }
            //            }
            //
            //            return step1.timeToStart! < step2.timeToStart!
            //
            return(step1.timeToStart! < step2.timeToStart!)
            
        }
        
        //TODO: create array instead of string for tableview
        
//        print("6")
//        for step in recipeSteps {
//            stepTitlesForDisplay.append("\(step.timeToStart)")
//        }
//        
//        print("7")
//        
//        store.recipeProceduresMerged = stepTitlesForDisplay.joined(separator: "\n\n")
//        print("8")
        
    }
    
 
}

extension String {
    func convertDurationToMinutes() -> Int {
        
        let separatedNum = self.components(separatedBy: ":")
        let handleMinutesOnly = Int(separatedNum[0])
        let handleHours = Int(separatedNum[0])
        let handleMinutesWithHours = Int(separatedNum[1])
        var totalMinutes: Int = 0
        
        switch separatedNum.count {
        case 2:
            totalMinutes += handleMinutesOnly!
        case 3:
            totalMinutes += ((handleHours! * 60) + (handleMinutesWithHours!))
        default:
            print("error")
        }
        
        return totalMinutes
    }

}
extension MergedStepsViewController {
    
    func convertDurationToMinutes(duration: String) -> Int {
        let separatedNum = duration.components(separatedBy: ":")
        let handleMinutesOnly = Int(separatedNum[0])
        let handleHours = Int(separatedNum[0])
        let handleMinutesWithHours = Int(separatedNum[1])
        var totalMinutes: Int = 0
        
        switch separatedNum.count {
        case 2:
            totalMinutes += handleMinutesOnly!
        case 3:
            totalMinutes += ((handleHours! * 60) + (handleMinutesWithHours!))
        default:
            print("error")
        }
        
        return totalMinutes
    }
    
    
}
