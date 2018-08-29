//
//  LoanTypeOptionalMediaTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/19/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypeOptionalMediaTBCell: LoanTypeBaseTBCell {
    
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
                
                self.updateData()
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
    
    //Url cac anh khong hop le
    var listURLInValid: [String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mainCollectionView?.delegate = self
        self.mainCollectionView?.dataSource = self
        self.mainCollectionView?.register(UINib(nibName: "LoanOtherInfoCollectionCell", bundle: nil), forCellWithReuseIdentifier: "Loan_Other_Info_Collection_Cell")
        
        self.updateData()
        
    }
    
    private func updateData() {
        guard let field_ = self.field, let indexArray = field_.arrayIndex, let _ = field_.title else { return }
        var temp: [String] = []
        
        if DataManager.shared.checkFieldIsMissing(key: "optionalMedia") {
            //Cap nhat thong tin khong hop le
            if let optionalMedia = DataManager.shared.missingOptionalMedia {
                if let listUrl = optionalMedia["\(indexArray)"] as? [String] {
                    if self.listURLInValid == nil {
                        self.listURLInValid = listUrl
                    }
                    
                    if let list = self.listURLInValid, list.count > 0 {
                        self.updateInfoFalse(pre: "Ảnh cung cấp")
                    }
                    
                }
            }
        }
        
        if let data = DataManager.shared.browwerInfo?.activeLoan?.optionalMedia, data.count > indexArray {
            if data[indexArray].count > 0 {
                temp = data[indexArray] as! [String]
            }
        }
        
        if DataManager.shared.loanInfo.optionalMedia.count > indexArray {
            temp = DataManager.shared.loanInfo.optionalMedia[indexArray]
            
            self.dataSourceCollection = temp
        }
        
    }
    
    func removeUrlInValidInList(url: String?) {
        if let list = self.listURLInValid {
            var index = 0
            var isRemove = false
            for i in list {
                if i == url {
                    isRemove = true
                    break
                }
                index += 1
            }
            if isRemove {
                self.listURLInValid?.remove(at: index)
            }
            
            if self.listURLInValid?.count == 0 {
                self.isNeedUpdate = false
            }
        }
    }
    
    func showLibrary() {
        CameraHandler.shared.showCamera(vc: UIApplication.shared.topViewController()!)
        CameraHandler.shared.imagePickedBlock = { (image) in
            //let img = FinPlusHelper.resizeImage(image: image, newWidth: 300)

            self.uploadData(img: image)
        }
    }
    
    //Upload Data Image
    func uploadData(img: UIImage) {
        //let dataImg = UIImagePNGRepresentation(img)
        guard let data = img.jpeg(.lowest) else { return }
        
        let loanID = DataManager.shared.loanID ?? 0
        //guard let data = dataImg else { return }
        let endPoint = "loans/" + "\(loanID)/" + "file"
        
        UIApplication.shared.topViewController()!.handleLoadingView(isShow: true)
        APIClient.shared.upload(type: self.typeImgFile, typeMedia: "image", endPoint: endPoint, imagesData: [data], parameters: ["" : ""], onCompletion: { (response) in
            UIApplication.shared.topViewController()!.handleLoadingView(isShow: false)
            print("Upload \(String(describing: response))")
            
            guard let res = response, let data = res["data"] as? [JSONDictionary], data.count > 0 else {
                //if let re = response {
                UIApplication.shared.topViewController()!.showToastWithMessage(message: "Có lỗi xảy ra, vui lòng thử lại" )
                //}
                
                return
            }
            //UIApplication.shared.topViewController()!.showToastWithMessage(message: "Upload thành công")
            
            //self.dataSourceCollection.append(img)
            if let current = self.currentSelectedCollection, current.row < self.dataSourceCollection.count {
                
                if let cell = self.mainCollectionView?.cellForItem(at: current) as? LoanOtherInfoCollectionCell, let hidden = cell.errorView?.isHidden, !hidden {
                    //remove key url invalid
                    self.removeUrlInValidInList(url: cell.urlImg)
                    
                }
                
                 self.dataSourceCollection[current.row] = img
                
            } else {
                self.dataSourceCollection.append(img)
            }
            
            //DataManager.shared.loanInfo.optionalMedia.removeAll()
            for d in data {
                if let url = d["url"] as? String {
                    
                    if DataManager.shared.loanInfo.optionalMedia.count == 0 {
                        DataManager.shared.loanInfo.optionalMedia = DataManager.shared.loanInfo.initOptionalMedia(cateId: DataManager.shared.loanInfo.loanCategoryID)
                    }
                    
                    if let indexArray = self.field?.arrayIndex, DataManager.shared.loanInfo.optionalMedia.count > indexArray {
                        
                        if let current = self.currentSelectedCollection, current.row < DataManager.shared.loanInfo.optionalMedia[indexArray].count {
                            DataManager.shared.loanInfo.optionalMedia[indexArray][current.row] = url
                        } else {
                            DataManager.shared.loanInfo.optionalMedia[indexArray].append(url)
                        }
                    }
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
        cell.errorView?.isHidden = true
        
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
        
        if let data = self.dataSourceCollection[indexPath.row] as? String {
            //cell.imgValue.sd_setImage(with: URL(string: hostLoan + data), completed: nil)
            cell.imgValue.sd_setImage(with: URL(string: data), placeholderImage: #imageLiteral(resourceName: "imagefirstOnboard"), completed: nil)
            cell.imgAdd.isHidden = true
            cell.btnDelete.isHidden = false
            cell.urlImg = data
            
            if let isNeed = self.isNeedUpdate, isNeed, let urls = self.listURLInValid, urls.count > 0 {
                for url in urls {
                    if data == url {
                        cell.errorView?.isHidden = false
                    }
                }
            }
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentSelectedCollection = indexPath
        self.showLibrary()
        
    }
    
}

extension LoanTypeOptionalMediaTBCell: OptionMediaDelegate {
    
    func deleteOptionMedia(index: Int, urlImg: String?) {
        
        self.removeUrlInValidInList(url: urlImg)
        self.dataSourceCollection.remove(at: index)
        
        if let indexArray = self.field?.arrayIndex, DataManager.shared.loanInfo.optionalMedia.count > indexArray {
            if DataManager.shared.loanInfo.optionalMedia[indexArray].count > index {
                DataManager.shared.loanInfo.optionalMedia[indexArray].remove(at: index)
            }
        }
        
        
    }
    
}




