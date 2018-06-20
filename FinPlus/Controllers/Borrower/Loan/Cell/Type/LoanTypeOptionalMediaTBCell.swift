//
//  LoanTypeOptionalMediaTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/19/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypeOptionalMediaTBCell: UITableViewCell {
    
    
    @IBOutlet var lblTitle: UILabel?
    @IBOutlet var mainCollectionView: UICollectionView?
    
    var currentSelectedCollection: IndexPath?
    
    
    var field: LoanBuilderFields? {
        didSet {
            guard let field_ = self.field else { return }
            
            if let title = field_.title {
                if field_.isRequired! {
                    self.lblTitle?.attributedText = FinPlusHelper.setAttributeTextForLoan(text: title)
                } else {
                    self.lblTitle?.text = title
                }
            }
            
        }
    }
    
    // Kiểu File Img
    var typeImgFile: FILE_TYPE_IMG = .Optional
    
    //Các dữ liệu khác image, video,...
    var dataSourceCollection: [Any] = [] {
        didSet {
            self.mainCollectionView?.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mainCollectionView?.delegate = self
        self.mainCollectionView?.dataSource = self
        self.mainCollectionView?.register(UINib(nibName: "LoanOtherInfoCollectionCell", bundle: nil), forCellWithReuseIdentifier: "Loan_Other_Info_Collection_Cell")
        
    }
    

    
    
    func showLibrary() {
        CameraHandler.shared.showActionSheet(vc: UIApplication.shared.topViewController()!)
        CameraHandler.shared.imagePickedBlock = { (image) in
            let img = FinPlusHelper.resizeImage(image: image, newWidth: 300)

            self.uploadData(img: img)
        }
        
    }
    
    //Upload Data Image
    func uploadData(img: UIImage) {
        let dataImg = UIImagePNGRepresentation(img)
        
        let loanID = DataManager.shared.loanID ?? 0
        guard let data = dataImg else { return }
        let endPoint = "loans/" + "\(loanID)/" + "file"
        
        UIApplication.shared.topViewController()!.handleLoadingView(isShow: true)
        APIClient.shared.upload(type: self.typeImgFile, typeMedia: "image", endPoint: endPoint, imagesData: [data], parameters: ["" : ""], onCompletion: { (response) in
            UIApplication.shared.topViewController()!.handleLoadingView(isShow: false)
            print("Upload \(String(describing: response))")
            UIApplication.shared.topViewController()!.showToastWithMessage(message: "Upload thành công")
            
            guard let res = response, let data = res["data"] as? [JSONDictionary], data.count > 0 else { return }

            self.dataSourceCollection.append(img)
            //DataManager.shared.loanInfo.optionalMedia.removeAll()
            for d in data {
                if let url = d["url"] as? String {
                    DataManager.shared.loanInfo.optionalMedia.append(url)
                }
            }
            

            
        }) { (error) in
            UIApplication.shared.topViewController()!.handleLoadingView(isShow: false)
            
            if let error = error {
                UIApplication.shared.topViewController()!.showToastWithMessage(message: error.localizedDescription)
                print("error \(error.localizedDescription)")
            }
        }
    }
    
    
}

extension LoanTypeOptionalMediaTBCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSourceCollection.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Loan_Other_Info_Collection_Cell", for: indexPath) as! LoanOtherInfoCollectionCell
        cell.currentSelectedCollection = indexPath
        cell.delegate = self
        
        guard indexPath.row < self.dataSourceCollection.count else {
            cell.imgValue.image = #imageLiteral(resourceName: "ic_loan_rectangle1")
            cell.imgAdd.isHidden = false
            cell.btnDelete.isHidden = true
            return cell
        }
        
        if let data = self.dataSourceCollection[indexPath.row] as? UIImage {
            cell.imgValue.image = data
            cell.imgAdd.isHidden = true
            cell.btnDelete.isHidden = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentSelectedCollection = indexPath
        self.showLibrary()
        
    }
    
}

extension LoanTypeOptionalMediaTBCell: OptionMediaDelegate {
    
    func deleteOptionMedia(index: Int) {
        self.dataSourceCollection.remove(at: index)
        if DataManager.shared.loanInfo.optionalMedia.count > index {
            DataManager.shared.loanInfo.optionalMedia.remove(at: index)
        }
    }
    
}




