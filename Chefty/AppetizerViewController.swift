//
//  AppetizerViewController.swift
//  Chefty
//
//  Created by Arvin San Miguel on 11/22/16.
//  Copyright © 2016 com.AppRising.SML. All rights reserved.
//

import UIKit

class AppetizerViewController: UIViewController {

    var store = DataStore.sharedInstance
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = CustomLayoutView()
        let frame = CGRect(x: view.bounds.minX, y: view.bounds.minY, width: view.bounds.width, height: view.bounds.height * 0.80)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: "recipeCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        view.addSubview(collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        self.store.tabSelectedOnMain = 1
    }
}

extension AppetizerViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.appetizer.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath) as! RecipeCollectionViewCell
        let url = URL(string: store.appetizer[indexPath.row].imageURL!)
        cell.recipe = store.appetizer[indexPath.row]
        cell.recipeLabel.text = store.appetizer[indexPath.row].displayName
        cell.imageView.sd_setImage(with: url!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let recipeCell = cell as! RecipeCollectionViewCell
        let interval = Double(indexPath.row)
        
        if (collectionView.frame.intersects(cell.frame)) {
            cell.alpha = 0.0
            cell.center.y = cell.center.y - 30
            
            UIView.animate(withDuration: 0.7 + (interval * 0.05), animations: {
                cell.alpha = 1.0
                cell.center.y += 30
            })
        }
        
        cell.alpha = 0.0
        cell.center.y = cell.center.y + 20
        
        UIView.animate(withDuration: 0.6 + (interval * 0.05), animations: {
            cell.alpha = 1.0
            cell.center.y -= 20
        })
        
        if store.recipesSelected.contains(recipeCell.recipe!) {
            let blue = UIColor(red: 35/255, green: 132/255, blue: 247/255, alpha: 1.0)
            recipeCell.layer.borderColor = blue.cgColor
            recipeCell.layer.borderWidth = 5.0
            recipeCell.alpha = 1.0
        } else {
            recipeCell.layer.borderWidth = 0.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipeView = TraditionalRecipeViewController()
        recipeView.cameFromVC = "main"
        recipeView.recipe = store.appetizer[indexPath.row]
        navigationController?.pushViewController(recipeView, animated: true)
    }
}
