//
//  SidesViewController.swift
//  Chefty
//
//  Created by Arvin San Miguel on 11/22/16.
//  Copyright © 2016 com.AppRising.SML. All rights reserved.
//

import UIKit

class SidesViewController: UIViewController {

    var store = DataStore.sharedInstance
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let layout = CustomLayoutView()
        let frame = CGRect(x: view.bounds.minX, y: view.bounds.maxY * 0.25, width: view.bounds.width, height: view.bounds.height * 0.75)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: "recipeCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        view.addSubview(collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
}

extension SidesViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return store.sides.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath) as! RecipeCollectionViewCell
        let url = URL(string: store.sides[indexPath.row].imageURL)
        cell.recipeLabel.text = store.sides[indexPath.row].displayName
        cell.imageView.sd_setImage(with: url!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
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
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let testView = TestTraditionalRecipeViewController()
        testView.recipe = store.sides[indexPath.row]
        present(testView, animated: true, completion: nil)
        
    }
    
}