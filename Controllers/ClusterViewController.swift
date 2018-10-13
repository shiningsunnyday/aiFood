//
//  ClusterViewController.swift
//  aiFood
//
//  Created by Michael Sun on 8/4/18.
//  Copyright © 2018 Michael Sun. All rights reserved.
//

import UIKit

import Firebase

class ClusterViewController: UICollectionViewController, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    var username = "Michael"
    var curValue: [String: [[Int]]] = ["count": [[]]]
    var sessionStarted = false

    func collectionView(collectionView: UICollectionView, canHandle: UIDropSession) -> Bool {
        return true
    }
    
    
    var result: ClusterResult = ClusterResult(list: [])
    var key: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = UIColor.yellow
        
        self.sessionStarted = false
        self.collectionView?.dragDelegate = self
        self.collectionView?.dropDelegate = self
        self.installsStandardGestureForInteractiveMovement = true
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 1
        return result.listOfIngredientLists.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader{
            var str = ""
            
            switch indexPath.section {
                
            case 0:
                
                str = "Breakfast"
            case 1:
                
                str = "Lunch"
            default:
                
                str = "Dinner"
                
            }
            sectionHeader.sizeToFit()
            sectionHeader.header.text = str

            sectionHeader.layer.bounds.insetBy(dx: 10, dy: 10)
            sectionHeader.sizeToFit()
            sectionHeader.layer.cornerRadius = 10
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clusterViewCollectionViewCell", for: indexPath) as! ClusterViewCollectionViewCell
        let ingredient = self.result.listOfIngredientLists[indexPath.section].listToDisplay[indexPath.row]
        cell.ingredientLabel.text = "I got selected!"
        cell.subtitle.text = "Protein: \(Int(ingredient.protein)) Fat: \(Int(ingredient.fat)) Carbs: \(Int(ingredient.carbs))"
        
    }
    
    

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 2
        
        return result.listOfIngredientLists[section].listToDisplay.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clusterViewCollectionViewCell", for: indexPath) as! ClusterViewCollectionViewCell
        cell.layer.cornerRadius = 10
        
        
        
        
        
        let ingredient = self.result.listOfIngredientLists[indexPath.section].listToDisplay[indexPath.row] 
        cell.ingredientLabel.text = "\(ingredient.amount) of \(ingredient.label)"
        cell.subtitle.text = "Protein: \(Int(ingredient.protein)) Fat: \(Int(ingredient.fat)) Carbs: \(Int(ingredient.carbs))"
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]
    {
        
        
        
        
        let nameref = Database.database().reference(withPath: "sessions")
        
        if !sessionStarted {
        
        let userref = nameref.child(self.username).childByAutoId()
        let key = userref.key
        self.key = key
        sessionStarted = true
        }
        let initial = result.listOfIngredientLists
        
        
 
        
        
        var ingredients: [String: [String]] = ["breakfast":[],"lunch":[],"dinner":[]]
        var dicConvert: [Int: String] = [0: "breakfast", 1: "lunch", 2: "dinner"]
        for i in 0...2 {
            
            let lang = dicConvert[i]
            for j in 0...(initial[i].listToDisplay.count - 1) {
                
                let name = initial[i].listToDisplay[j].label
                ingredients[lang!]!.append(name)
                
            }
            
        }
        
        let ingredientsDic = ["initial": ingredients] as NSDictionary
        
        nameref.child(self.username).child(self.key).setValue(ingredientsDic as! [AnyHashable: Any])
        let tempref = Database.database().reference(withPath: "sessions/\(self.username)/\(self.key)")
        
        let ingredient = self.result.listOfIngredientLists[indexPath.section].listToDisplay[indexPath.row]
        
        
        tempref.child("count").setValue(["count": []])
        let runningString = "\(ingredient.label),\(ingredient.amount),\(ingredient.calories),\(ingredient.protein),\(ingredient.fat),\(ingredient.carbs)"
        
        
        
        
        let itemProvider = NSItemProvider(object: runningString as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = ingredient
        return [dragItem]
            
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal
    {
        
        
        if session.localDragSession != nil
        {
            if collectionView.hasActiveDrag
            {
                
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
            else
            {
                
                
                return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
            }
        }
        else
        {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator)
    {
        
        
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath
        {
            destinationIndexPath = indexPath
        }
        else
        {
            // Get last index path of collection view.
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        switch coordinator.proposal.operation
        {
        case .move:
            //Add the code to reorder items
            
            collectionView.performBatchUpdates({
                var indexPaths = [IndexPath]()
                var sourcePaths = [IndexPath]()
                for (index, item) in coordinator.items.enumerated()
                {
                    //Destination index path for each item is calculated separately using the destinationIndexPath fetched from the coordinator
                    let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                    let sourcePath = IndexPath(row: item.sourceIndexPath!.row + index, section: item.sourceIndexPath!.section)
                    let itemAddBack = item.dragItem.localObject as! Ingredient
                    self.result.listOfIngredientLists[sourcePath.section].remove(ingredient: itemAddBack, row: (item.sourceIndexPath?.row)!)
                    self.result.listOfIngredientLists[indexPath.section].insert(ingredient: itemAddBack, row: indexPath.row)
                    
                    let nameref = Database.database().reference(withPath: "sessions/\(self.username)/\(self.key)/changes")
                    
                    
                    self.curValue["count"]!.append([sourcePath.section, sourcePath.row, indexPath.section, indexPath.row])
                    nameref.updateChildValues(self.curValue)
                    indexPaths.append(indexPath)
                    sourcePaths.append(sourcePath)
                }
                
                collectionView.deleteItems(at: sourcePaths)
                collectionView.insertItems(at: indexPaths)
                
            })
            
            
            
            break
            
        case .copy:
            //Add the code to copy items
            
            break
            
        default:
            return
        }
    }
    
}

