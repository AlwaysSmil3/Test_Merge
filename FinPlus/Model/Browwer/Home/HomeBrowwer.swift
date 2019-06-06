//
//  HomeBrowwer.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/5/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

struct HomeBrowModel {
    var icon: UIImage
    var name: String
    var distanceAmount: String
}

let homeBrowModels = [
    HomeBrowModel(icon: #imageLiteral(resourceName: "ic_homeBrower_group1"), name: "Vay cho \nsinh viên", distanceAmount: "1-5 triệu"),
    HomeBrowModel(icon: #imageLiteral(resourceName: "ic_homeBrower_group2"), name: "Vay mua \nđiện thoại", distanceAmount: "1-15 triệu"),
    HomeBrowModel(icon: #imageLiteral(resourceName: "ic_homeBrower_group3"), name: "Vay mua \nxe máy", distanceAmount: "1-15 triệu"),
    HomeBrowModel(icon: #imageLiteral(resourceName: "ic_homeBrower_group4"), name: "Vay cho \nđám cưới", distanceAmount: "1-15 triệu"),
    HomeBrowModel(icon: #imageLiteral(resourceName: "ic_homeBrower_group5"), name: "Vay cho \nbà bầu", distanceAmount: "1-15 triệu"),
    HomeBrowModel(icon: #imageLiteral(resourceName: "ic_homeBrower_group6"), name: "Vay cho \nem bé", distanceAmount: "1-15 triệu"),
    HomeBrowModel(icon: #imageLiteral(resourceName: "ic_homeBrower_group7"), name: "Vay cho \nnội thất", distanceAmount: "1-15 triệu"),
    HomeBrowModel(icon: #imageLiteral(resourceName: "ic_homeBrower_group8"), name: "Vay cho chi \nphí y tế", distanceAmount: "1-15 triệu"),
    HomeBrowModel(icon: #imageLiteral(resourceName: "ic_homeBrower_group9"), name: "Vay hợp \nnhất nợ", distanceAmount: "1-15 triệu"),
    HomeBrowModel(icon: #imageLiteral(resourceName: "ic_homeBrower_group10"), name: "Vay khác", distanceAmount: "1-10 triệu"),

]
