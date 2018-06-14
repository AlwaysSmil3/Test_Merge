//
//  LoanOtherInfoVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation


class LoanOtherInfoVC: LoanBaseViewController {
    
    @IBOutlet var mainCollectionView: UICollectionView!
    
    //Các dữ liệu khác image, video,...
    var dataSourceCollection: [Any] = [] {
        didSet {
            self.mainCollectionView.reloadData()
        }
    }
    
    var currentSelectedCollection: IndexPath?
    
    override func viewDidLoad() {
        self.index = 3
        super.viewDidLoad()
        
        self.updateDataToServer()
        
        if let bottomView = self.bottomScrollView {
            bottomView.setContentOffset(CGPoint(x: 100, y: 0), animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    //MARK: ACtions

    @IBAction func btnContinueTapped(_ sender: Any) {
        
        if DataManager.shared.loanInfo.optionalText.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập lương tháng của bạn")
            return
        }
        
        if DataManager.shared.loanInfo.optionalMedia.count == 0 {
            self.showToastWithMessage(message: "Vui lòng tải ảnh bảng lương/ chấm công của bạn")
            return
        }
        
        
        let loanSummaryInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanSummaryInfoVC") as! LoanSummaryInfoVC
        
        self.navigationController?.pushViewController(loanSummaryInfoVC, animated: true)
    }
    
    func showLibrary() {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            let img = FinPlusHelper.resizeImage(image: image, newWidth: 300)
            
            self.dataSourceCollection.append(img)
            
            self.uploadData(img: img)
            
        }
        
    }
    
}


extension LoanOtherInfoVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
        self.currentSelectedCollection = indexPath
        self.typeImgFile = .Optional
        self.showLibrary()
        
    }

}

//MARK: UICollection View Delegate Flow Layout
extension LoanOtherInfoVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (BOUND_SCREEN.size.width - 32) / 3
        return CGSize(width: width, height: width)
    }
    
}


