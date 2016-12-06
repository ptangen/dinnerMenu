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
    
    var store = DataStore.sharedInstance
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViewAndTableView()

        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool = false) {
        self.title = "Merged Recipe Steps"
        self.tableView.reloadData()
        print("reloading data on view will appear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.mergedStepsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MergedStepsTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        if let stepTitle = store.mergedStepsArray[indexPath.row].stepTitle {
            cell.textLabel?.text = "\(stepTitle) (\(store.mergedStepsArray[indexPath.row].timeToStart))"
        }
        self.getImage(recipe: store.mergedStepsArray[indexPath.row].recipe!, imageView: cell.imageViewInst, view: cell)
        return cell
    }
    
    
    func createViewAndTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView)
        
        let myView = UIView()
        self.view.addSubview(myView)
        
        let myLabel = UILabel()
        self.view.addSubview(myLabel)
        
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        myView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        myView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        myView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myLabel.widthAnchor.constraint(equalTo: myView.widthAnchor, multiplier: 1.0).isActive = true
        myLabel.leftAnchor.constraint(equalTo: myView.leftAnchor).isActive = true
        myLabel.bottomAnchor.constraint(equalTo: myView.bottomAnchor).isActive = true
        myLabel.text = "Start cooking at \(store.startCookingTime)"
        myLabel.font = myLabel.font?.withSize(24)
        myLabel.textAlignment = .center
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1.0).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: myView.bottomAnchor).isActive = true
    }
    
    
    func getImage(recipe: Recipe, imageView: UIImageView, view: UIView) {
        if let imageURLString = recipe.imageURLSmall {
            let url = URL(string: imageURLString)
            imageView.contentMode = .scaleAspectFit
            imageView.sd_setImage(with: url!)
            view.addSubview(imageView)
        }
    }
    

}

