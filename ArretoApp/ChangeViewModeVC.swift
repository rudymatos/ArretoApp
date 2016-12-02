//
//  ChangeViewModeVC.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 11/23/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class ChangeViewModeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView?
    private var selectedIndex : IndexPath?
    var selectedViewMode = ViewModeEnum.all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        configureView()
    }
    
    @IBAction func applyChanges(_ sender: UIButton) {
        performSegue(withIdentifier: "backToMainFromChangeViewSegue", sender: nil)
    }
    
    func configureView(){
        if let index = ViewModeEnum.allValues.index(of: selectedViewMode), let collectionView = collectionView{
            let indexPath = IndexPath(item: index, section: 0)
            changeSelection(collectionView: collectionView, indexPath: indexPath)
        }
    }
    
    
    private func changeSelection(collectionView : UICollectionView, indexPath: IndexPath){
        
        if selectedIndex != nil{
            let previousCell = collectionView.cellForItem(at: selectedIndex!) as? ViewModeCVC
            previousCell?.changeSelectionColor()
        }
        
        selectedIndex = indexPath
        let selectedCell = collectionView.cellForItem(at: indexPath) as? ViewModeCVC
        UIView.animate(withDuration: 1.0, animations: {
            selectedCell?.changeSelectionColor()
        })
        selectedViewMode = ViewModeEnum.allValues[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        changeSelection(collectionView: collectionView, indexPath: indexPath)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ViewModeEnum.allValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "viewModeCell", for: indexPath) as! ViewModeCVC
        let currentViewMode = ViewModeEnum.allValues[indexPath.item]
        cell.currentViewMode = currentViewMode
        return cell
    }
    
    
}
