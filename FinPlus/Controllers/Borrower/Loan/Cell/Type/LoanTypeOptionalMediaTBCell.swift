//
//  LoanTypeOptionalMediaTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/19/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypeOptionalMediaTBCell: UITableViewCell {
    
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var mainCollectionView: UICollectionView!
    
    var currentSelectedCollection: IndexPath?
    
    var field: LoanBuilderFields?
    
    //Các dữ liệu khác image, video,...
    var dataSourceCollection: [Any] = [] {
        didSet {
            self.mainCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mainCollectionView.delegate = self
        self.mainCollectionView.dataSource = self
        self.mainCollectionView.register(UINib(nibName: "LoanOtherInfoCollectionCell", bundle: nil), forCellWithReuseIdentifier: "Loan_Other_Info_Collection_Cell")
        
    }
    

    
    
    func showLibrary() {
//        CameraHandler.shared.showActionSheet(vc: self)
//        CameraHandler.shared.imagePickedBlock = { (image) in
//            let img = FinPlusHelper.resizeImage(image: image, newWidth: 300)
//
//            self.dataSourceCollection.append(img)
//
//            self.uploadData(img: img)
//
//        }
        
    }
    
    
}

extension LoanTypeOptionalMediaTBCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSourceCollection.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Loan_Other_Info_Collection_Cell", for: indexPath) as! LoanOtherInfoCollectionCell
        
        guard indexPath.row < self.dataSourceCollection.count else {
            cell.imgValue.image = #imageLiteral(resourceName: "ic_loan_rectangle1")
            cell.imgAdd.isHidden = false
            
            return cell
        }
        
        if let data = self.dataSourceCollection[indexPath.row] as? UIImage {
            cell.imgValue.image = data
            cell.imgAdd.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.currentSelectedCollection = indexPath
//        self.typeImgFile = .Optional
//        self.showLibrary()
        
    }
    
}




