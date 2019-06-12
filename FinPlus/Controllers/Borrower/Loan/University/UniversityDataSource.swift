//
//  UniversityDataSource.swift
//  FinPlus
//
//  Created by Cao Van Hai on 9/6/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

protocol Item {}

protocol UniversityDataSourceProtocol {
    func numberOfSections() -> Int
    func numberOfItemsInSection(_ section: Int) -> Int
    func itemAtIndexPath(_ indexPath: IndexPath) -> Item?
    func titleForHeaderInSection(_ section: Int) -> String?
}

extension String : Item {}

struct UniversityDataSource : UniversityDataSourceProtocol {
    fileprivate(set) var sections = [[String]]()
    fileprivate let collaction = UILocalizedIndexedCollation.current()
    
    init() {
        sections = split(loadCountryNames())
    }
    
    fileprivate func loadCountryNames() -> [String] {
        return Locale.isoRegionCodes.map { (code) -> String in
            return Locale.current.localizedString(forRegionCode: code)!
        }
    }
    
    fileprivate func split(_ items: [String]) -> [[String]] {
        let collation = UILocalizedIndexedCollation.current()
        let items = collation.sortedArray(from: items, collationStringSelector: #selector(NSObject.description)) as! [String]
        var sections = [[String]](repeating: [], count: collation.sectionTitles.count)
        for item in items {
            let index = collation.section(for: item, collationStringSelector: #selector(NSObject.description))
            sections[index].append(item)
        }
        return sections
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return sections[section].count
    }
    
    func itemAtIndexPath(_ indexPath: IndexPath) -> Item? {
        return sections[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).item]
    }
    
    func titleForHeaderInSection(_ section: Int) -> String? {
        return collaction.sectionTitles[section]
    }
}
