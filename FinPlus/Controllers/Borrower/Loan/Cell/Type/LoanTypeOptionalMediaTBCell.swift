//
//  LoanTypeOptionalMediaTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/19/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import SDWebImage

class LoanTypeOptionalMediaTBCell: LoanTypeBaseTBCell {
    
    @IBOutlet weak var mainCollectionView: UICollectionView?
    
    var currentSelectedCollection: IndexPath?
    var MAX_COUNT_IMAGE = 20
    
    var field: LoanBuilderFields? {
        didSet {
            guard let field_ = self.field else { return }
            
            let title = field_.title ?? "Khác"
            if field_.isRequired! {
                self.lblTitle?.attributedText = FinPlusHelper.setAttributeTextForLoan(text: title)
            } else {
                self.lblTitle?.text = title
            }
            
            self.updateData()
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
    //List url invalid removed
    var listRemovedURLInvalid: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainCollectionView?.delegate = self
        self.mainCollectionView?.dataSource = self
        self.mainCollectionView?.register(UINib(nibName: "LoanOtherInfoCollectionCell", bundle: nil), forCellWithReuseIdentifier: "Loan_Other_Info_Collection_Cell")
        self.updateData()
    }
    
    private func updateData() {
        guard let field_ = self.field, let indexArray = field_.arrayIndex else { return }
        var temp: [String] = []
        
        if DataManager.shared.checkFieldIsMissing(key: "optionalMedia") {
            //Cap nhat thong tin khong hop le
            if let optionalMedia = DataManager.shared.missingOptionalMedia {
                if let listUrlJSON = optionalMedia["\(indexArray)"] as? JSONDictionary {
                    
                    var listUrl: [String] = []
                    
                    for i in 0...MAX_COUNT_IMAGE {
                        if let url = listUrlJSON["\(i)"] as? String {
                            listUrl.append(url)
                        }
                    }
                    
                    self.listURLInValid = listUrl
                    self.updateListURLInvalid()
                    
                    if let list = self.listURLInValid, list.count > 0 {
                        self.updateInfoFalse(pre: "Ảnh cung cấp")
                    } else {
                        self.isNeedUpdate = false
                    }
                } else {
                    self.isNeedUpdate = false
                }
            } else {
                if let need = self.isNeedUpdate, need {
                    self.isNeedUpdate = false
                }
            }
        } else {
            if let need = self.isNeedUpdate, need {
                self.isNeedUpdate = false
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
            for (index_, i) in list.enumerated() {
                if i == url {
                    index = index_
                    isRemove = true
                    break
                }
            }
            if isRemove {
                self.listURLInValid?.remove(at: index)
            }
            
            if self.listURLInValid?.count == 0 {
                self.isNeedUpdate = false
            }
        }
    }
    
    func addToListURLInvalid(url: String) {
        let temp = self.listRemovedURLInvalid.filter{ $0 == url }
        if temp.count == 0 {
            self.listRemovedURLInvalid.append(url)
        }
    }
    
    private func updateListURLInvalid() {
        
        self.listRemovedURLInvalid.forEach { (url) in
            var index = 0
            var isRemove = false
            
            if let list = self.listURLInValid {
                for (index_, i) in list.enumerated() {
                    if i == url {
                        index = index_
                        isRemove = true
                        break
                    }
                }
                
                if isRemove {
                    if index < list.count {
                        self.listURLInValid?.remove(at: index)
                    }
                }
            }
        }
    }
    
    /// Show Alert for chossen image from galery
    func showAlertAllowGetImageFromGalery() {
        
        let alert = UIAlertController(title: "Chọn ảnh", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Chụp ảnh", style: UIAlertActionStyle.default) { (action) in
            self.showCameraView()
        }
        let galeryAction = UIAlertAction(title: "Chọn ảnh", style: UIAlertActionStyle.default) { (action) in
            self.showLibrary()
        }
        let cancelAction = UIAlertAction(title: "Đóng", style: UIAlertActionStyle.cancel) { (action) in
            
        }
        
        alert.view.tintColor = MAIN_COLOR
        
        alert.addAction(cameraAction)
        alert.addAction(galeryAction)
        alert.addAction(cancelAction)
        
        if let popoverPresentationController = alert.popoverPresentationController, let topVC = UIApplication.shared.topViewController() {
            popoverPresentationController.sourceView = topVC.view
            popoverPresentationController.sourceRect = CGRect(x: 20, y: 20, width: 64, height: 64)
        }
        
        UIApplication.shared.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func showLibrary() {
        CameraHandler.shared.photoLibrary(vc: UIApplication.shared.topViewController()!)
        CameraHandler.shared.imagePickedBlock = { (image) in
            //let img = FinPlusHelper.resizeImage(image: image, newWidth: 300)
            self.uploadData(img: image)
        }
    }
    
    func showCameraView() {
        if #available(iOS 10.0, *) {
            let cameraVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
            cameraVC.delegateCamera = self
            cameraVC.typeImgFile = self.typeImgFile
            cameraVC.descriptionText = self.field?.title ?? ""
            
            guard let topVC = UIApplication.shared.topViewController() else { return }
            topVC.present(cameraVC, animated: true)
        } else {
            self.showLibrary()
        }
    }
    
    //Upload Data Image
    func uploadData(img: UIImage) {
        
        guard let topVC = UIApplication.shared.topViewController() else { return }
        topVC.handleLoadingView(isShow: true)
        guard let imgResize = img.resizeMonyImage(originSize: img.size), let data = imgResize.jpeg(.lowest) else {
            topVC.handleLoadingView(isShow: false)
            return
        }
        
        let loanID = DataManager.shared.loanID ?? 0
        //guard let data = dataImg else { return }
        let endPoint = "\(APIService.LoanService)loans/" + "\(loanID)/" + "file"
        
        APIClient.shared.upload(type: self.typeImgFile, typeMedia: "image", endPoint: endPoint, imagesData: [data], parameters: ["" : ""], onCompletion: { [weak self](response) in
            topVC.handleLoadingView(isShow: false)
            
            guard let res = response, let data = res["data"] as? [JSONDictionary], data.count > 0 else {
                topVC.showToastWithMessage(message: "Có lỗi xảy ra, vui lòng thử lại" )
                return
            }
            guard let strongSelf = self else { return }
            
            if let current = strongSelf.currentSelectedCollection, current.row < strongSelf.dataSourceCollection.count {
                if let cell = strongSelf.mainCollectionView?.cellForItem(at: current) as? LoanOtherInfoCollectionCell, let hidden = cell.errorView?.isHidden, !hidden {
                    //remove key url invalid
                    strongSelf.removeUrlInValidInList(url: cell.urlImg)
                    if let urlImg = cell.urlImg {
                        strongSelf.addToListURLInvalid(url: urlImg)
                    }
                }
                strongSelf.dataSourceCollection[current.row] = img
            } else {
                strongSelf.dataSourceCollection.append(img)
            }
            
            for data in data {
                if let url = data["url"] as? String {
                    if DataManager.shared.loanInfo.optionalMedia.count == 0 {
                        DataManager.shared.loanInfo.optionalMedia = DataManager.shared.loanInfo.initOptionalMedia(cateId: DataManager.shared.loanInfo.loanCategoryID)
                    }
                    
                    if let indexArray = strongSelf.field?.arrayIndex, DataManager.shared.loanInfo.optionalMedia.count > indexArray {
                        if let current = strongSelf.currentSelectedCollection, current.row < DataManager.shared.loanInfo.optionalMedia[indexArray].count {
                            DataManager.shared.loanInfo.optionalMedia[indexArray][current.row] = url
                        } else {
                            DataManager.shared.loanInfo.optionalMedia[indexArray].append(url)
                        }
                    }
                }
            }
        }) { (error) in
            topVC.handleLoadingView(isShow: false)
            topVC.showToastWithMessage(message: "Có lỗi xảy ra, vui lòng thử lại" )
            if let error = error {
                print("error \(error.localizedDescription)")
            }
        }
    }
    
}

//MARK: DataImageFromCameraCaptureDelegate
extension LoanTypeOptionalMediaTBCell: DataImageFromCameraCaptureDelegate {
    func getImage(image: UIImage, type: FILE_TYPE_IMG?) {
        self.uploadData(img: image)
    }
}

//MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension LoanTypeOptionalMediaTBCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.dataSourceCollection.count >= MAX_COUNT_IMAGE {
            return self.dataSourceCollection.count
        }
        return self.dataSourceCollection.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Loan_Other_Info_Collection_Cell", for: indexPath) as! LoanOtherInfoCollectionCell
        cell.currentSelectedCollection = indexPath
        cell.delegate = self
        cell.errorView.isHidden = true
        
        if self.dataSourceCollection.count < MAX_COUNT_IMAGE && indexPath.row == self.dataSourceCollection.count {
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
//            cell.imgValue.kf.setImage(with: URL(string: data), placeholder: #imageLiteral(resourceName: "imagefirstOnboard"), options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
            cell.imgValue.sd_setImage(with: URL(string: data), placeholderImage: #imageLiteral(resourceName: "imagefirstOnboard"), options: .transformAnimatedImage)
            cell.imgAdd.isHidden = true
            cell.btnDelete.isHidden = false
            cell.urlImg = data
            
            if let isNeed = self.isNeedUpdate, isNeed, let urls = self.listURLInValid, urls.count > 0 {
                var isNoShowErrorView = true
                for url in urls where data == url {
                    isNoShowErrorView = false
                    break
                }
                cell.errorView.isHidden = isNoShowErrorView
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentSelectedCollection = indexPath
        
        guard let isAllowGetImageFromGalery = self.field?.allowGetImageFromGalery, isAllowGetImageFromGalery else {
            self.showCameraView()
            return
        }
        self.showAlertAllowGetImageFromGalery()
        //self.showLibrary()
        //self.showCameraView()
    }
    
}

extension LoanTypeOptionalMediaTBCell: OptionMediaDelegate {
    
    func deleteOptionMedia(index: Int, urlImg: String?) {
        self.removeUrlInValidInList(url: urlImg)
        self.dataSourceCollection.remove(at: index)
        
        if let urlImg_ = urlImg {
            self.addToListURLInvalid(url: urlImg_)
        }
        
        if let indexArray = self.field?.arrayIndex, DataManager.shared.loanInfo.optionalMedia.count > indexArray {
            if DataManager.shared.loanInfo.optionalMedia[indexArray].count > index {
                DataManager.shared.loanInfo.optionalMedia[indexArray].remove(at: index)
            }
        }
    }
    
}
