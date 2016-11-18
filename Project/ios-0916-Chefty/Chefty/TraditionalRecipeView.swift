//
//  TraditionalRecipeView.swift
//  Chefty
//
//  Created by Jacqueline Minneman on 11/17/16.
//  Copyright © 2016 com.AppRising.SML. All rights reserved.
//


import UIKit

class TraditionalRecipeView: UIView {
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        setUpElements()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    func setUpElements() {
        
        //SCROLLVIEW
        let myScrollView = UIScrollView()
        self.addSubview(myScrollView)
        
        myScrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        myScrollView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        myScrollView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //myScrollView.contentSize = CGSize(width: frame.size.width, height: 1000)
        
        myScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // create image
        let myImageName = "applePie"
        let myImage = UIImage(named: myImageName)
        let myImageView = UIImageView(image: myImage!)
       
        myScrollView.addSubview(myImageView)
        
        // constrain the image
        myImageView.topAnchor.constraint(equalTo: myScrollView.topAnchor).isActive = true
        myImageView.widthAnchor.constraint(equalTo: myScrollView.widthAnchor).isActive = true
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        //RECIPE TITLE
        //create title label
        let titleLabel = UILabel()
        titleLabel.text = "Recipe Title"
        titleLabel.font = titleLabel.font.withSize(30)
        titleLabel.textAlignment = .center
        
        myScrollView.addSubview(titleLabel)
        
        // constrain label
        titleLabel.centerXAnchor.constraint(equalTo: myScrollView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: myImageView.bottomAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        
        //SERVING SIZE AND ESTIMATED TIME INFO
        //create labels
        let servingSizeLabel = UILabel()
        servingSizeLabel.text = "Serving Size: 4-6"
        servingSizeLabel.font = titleLabel.font.withSize(20)
        servingSizeLabel.textAlignment = .left
        
        let durationLabel = UILabel()
        durationLabel.text = "Estimated Total Time: 26 minutes"
        durationLabel.font = titleLabel.font.withSize(20)
        durationLabel.textAlignment = .left
        
        myScrollView.addSubview(servingSizeLabel)
        myScrollView.addSubview(durationLabel)
        
        // constrain labels
        servingSizeLabel.leftAnchor.constraint(equalTo: myScrollView.leftAnchor, constant: 10).isActive = true
        servingSizeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        servingSizeLabel.widthAnchor.constraint(equalTo: myScrollView.widthAnchor).isActive = true
        servingSizeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        servingSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        durationLabel.leftAnchor.constraint(equalTo: myScrollView.leftAnchor, constant: 10).isActive = true
        durationLabel.topAnchor.constraint(equalTo: servingSizeLabel.bottomAnchor).isActive = true
        durationLabel.widthAnchor.constraint(equalTo: myScrollView.widthAnchor).isActive = true
        durationLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        //INGREDIENTS LABEL
        //create label
        let ingredientsLabel = UILabel()
        ingredientsLabel.text = "Ingredients"
        ingredientsLabel.font = titleLabel.font.withSize(16)
        ingredientsLabel.textAlignment = .left
        
        myScrollView.addSubview(ingredientsLabel)
        
        //constrain label
        ingredientsLabel.leftAnchor.constraint(equalTo: myScrollView.leftAnchor, constant: 10).isActive = true
        ingredientsLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 10).isActive = true
        ingredientsLabel.widthAnchor.constraint(equalTo: myScrollView.widthAnchor).isActive = true
        ingredientsLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        //INGREDIENTS TEXT BOX
        //create textbox
        let ingredientsText = UITextView()
        ingredientsText.text = "Lorem ipsum dolor sit amet \nconsectetur adipiscing elit \nsed do eiusmod tempor \nincididunt ut labore \net dolore magna aliqua***Lorem ipsum dolor sit amet \nconsectetur adipiscing elit"
        ingredientsText.font = titleLabel.font.withSize(14)
        ingredientsText.textAlignment = .left
        
        myScrollView.addSubview(ingredientsText)
        
        // constrain textbox
        let ingredientsContentSize = ingredientsText.sizeThatFits(ingredientsText.bounds.size)
        var ingredientsFrame = ingredientsText.frame
        ingredientsFrame.size.height = ingredientsContentSize.height
        ingredientsText.frame = ingredientsFrame
        
        ingredientsText.leftAnchor.constraint(equalTo: myScrollView.leftAnchor, constant: 10).isActive = true
        ingredientsText.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor).isActive = true
        ingredientsText.widthAnchor.constraint(equalTo: myScrollView.widthAnchor).isActive = true
        ingredientsText.heightAnchor.constraint(equalToConstant: ingredientsText.frame.size.height).isActive = true
        ingredientsText.translatesAutoresizingMaskIntoConstraints = false
        ingredientsText.isScrollEnabled = false
        
        
        //STEPS LABEL
        //create label
        let stepsLabel = UILabel()
        stepsLabel.text = "Steps"
        stepsLabel.font = titleLabel.font.withSize(16)
        stepsLabel.textAlignment = .left
        
        myScrollView.addSubview(stepsLabel)
        
        //constrain label
        stepsLabel.leftAnchor.constraint(equalTo: myScrollView.leftAnchor, constant: 10).isActive = true
        stepsLabel.topAnchor.constraint(equalTo: ingredientsText.bottomAnchor, constant: 10).isActive = true
        stepsLabel.widthAnchor.constraint(equalTo: myScrollView.widthAnchor).isActive = true
        stepsLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        stepsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        //STEPS TEXT BOX
        //create textbox
        let stepsText = UITextView()
        stepsText.text = "Lorem ipsum dolor sit amet \nconsectetur adipiscing elit \nsed do eiusmod tempor \nincididunt ut labore \net dolore magna aliqua\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque \nlaudantium totam rem aperiam eaque ipsa quae ab \nillo inventore veritatis et quasi \narchitecto beatae vitae dicta sunt explicabo\n Nemo enim ipsam voluptatem \nquia voluptas sit aspernatur aut odit aut fugit \nsed quia consequuntur magni \ndolores eos qui ratione voluptatem \nsequi nesciunt \nNeque porro quisquam est \nqui dolorem ipsum quia dolor sit amet \nconsectetur adipisci velitEND IS HERE"
        stepsText.font = titleLabel.font.withSize(14)
        stepsText.textAlignment = .left
        
        myScrollView.addSubview(stepsText)
        
        // constrain textbox
        let stepsContentSize = stepsText.sizeThatFits(stepsText.bounds.size)
        var stepsFrame = stepsText.frame
        stepsFrame.size.height = stepsContentSize.height
        stepsText.frame = stepsFrame
        
        stepsText.leftAnchor.constraint(equalTo: myScrollView.leftAnchor, constant: 10).isActive = true
        stepsText.topAnchor.constraint(equalTo: stepsLabel.bottomAnchor).isActive = true
        stepsText.bottomAnchor.constraint(equalTo: myScrollView.bottomAnchor).isActive = true
        stepsText.widthAnchor.constraint(equalTo: myScrollView.widthAnchor).isActive = true
        stepsText.heightAnchor.constraint(equalToConstant: ingredientsText.frame.size.height).isActive = true
        
        stepsText.translatesAutoresizingMaskIntoConstraints = false
        stepsText.isScrollEnabled = false
    }
}
