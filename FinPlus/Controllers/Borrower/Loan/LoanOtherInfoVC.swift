//
//  LoanOtherInfoVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
//import Fusuma

class LoanOtherInfoVC: LoanBaseViewController {
    
    @IBOutlet var mainCollectionView: UICollectionView!
    
    var dataSourceCollection: [Any] = []
    var currentSelectedCollection: IndexPath?
    
    override func viewDidLoad() {
        self.index = 3
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateDataToServer()
    }
    
    //MARK: ACtions
    
    @IBAction func btnLoanImgOtherInfoTapped(_ sender: Any) {
        //self.setupFusuma()
    }
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        
        
        let loanSummaryInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanSummaryInfoVC") as! LoanSummaryInfoVC
        
        self.navigationController?.pushViewController(loanSummaryInfoVC, animated: true)
    }
    
    func showLibrary() {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            let img = FinPlusHelper.resizeImage(image: image, newWidth: 300)
            
            guard let indexPath = self.currentSelectedCollection else { return }

            if let cell = self.mainCollectionView.cellForItem(at: indexPath) as? LoanOtherInfoVC {
                
            }
        }
        
    }
    
}


extension LoanOtherInfoVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSourceCollection.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Loan_Other_Info_Collection_Cell", for: indexPath) as! LoanOtherInfoCollectionCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentSelectedCollection = indexPath
        
        
        
        
    }

    
    
}


