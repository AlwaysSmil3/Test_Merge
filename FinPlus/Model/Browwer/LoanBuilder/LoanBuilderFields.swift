//
//  LoanBuilderFields.swift
//
//  Created by Cao Van Hai on 7/10/18
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct LoanBuilderFields {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let suffix = "suffix"
    static let data = "data"
    static let selectorTitle = "selector_title"
    static let multipleLine = "multiple_line"
    static let descriptionValue = "description"
    static let showData = "show_data"
    static let type = "type"
    static let multipleData = "multiple_data"
    static let index = "index"
    static let id = "id"
    static let isRequired = "is_required"
    static let title = "title"
    static let placeholder = "placeholder"
    static let keyboard = "keyboard"
    static let showTime = "show_time"
    static let arrayIndex = "array_index"
    static let dataName = "data_name"
    static let maxLength = "max_length"
    
    static let display_if_loan_over = "display_if_loan_over"
    static let display_if_job_type_is = "display_if_job_type_is"
    static let display_if_need_additional_missing_data = "display_if_need_additional_missing_data"
    
  }

  // MARK: Properties
  public var suffix: String?
  public var data: [LoanBuilderData]?
  public var selectorTitle: String?
  public var multipleLine: Bool? = false
  public var descriptionValue: String?
  public var showData: Bool? = false
  public var type: String?
  public var multipleData: [LoanBuilderMultipleData]?
  public var index: Int?
  public var id: String?
  public var isRequired: Bool? = false
  public var title: String?
  public var placeholder: String?
  public var keyboard: String?
  public var showTime: Bool? = false
    public var arrayIndex: Int?
    public var textInputMuiltiline: String?
    public var dataName: String?
    public var maxLenght: Int?
    
    public var displayIfLoanOver: Double?
    public var displayIfJobTypeIs: [Int]?
    public var isCanDisplay: Bool = true
    public var displayIfNeedAdditionalMissingData: Bool?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public init(json: JSON) {
    suffix = json[SerializationKeys.suffix].string
    if let items = json[SerializationKeys.data].array { data = items.map { LoanBuilderData(json: $0) } }
    selectorTitle = json[SerializationKeys.selectorTitle].string
    multipleLine = json[SerializationKeys.multipleLine].boolValue
    descriptionValue = json[SerializationKeys.descriptionValue].string
    showData = json[SerializationKeys.showData].boolValue
    type = json[SerializationKeys.type].string
    if let items = json[SerializationKeys.multipleData].array { multipleData = items.map { LoanBuilderMultipleData(json: $0) } }
    index = json[SerializationKeys.index].int
    id = json[SerializationKeys.id].string
    isRequired = json[SerializationKeys.isRequired].boolValue
    title = json[SerializationKeys.title].string
    placeholder = json[SerializationKeys.placeholder].string
    keyboard = json[SerializationKeys.keyboard].string
    showTime = json[SerializationKeys.showTime].boolValue
    arrayIndex = json[SerializationKeys.arrayIndex].int
    dataName = json[SerializationKeys.dataName].string
    maxLenght = json[SerializationKeys.maxLength].int
    
    self.displayIfLoanOver = json[SerializationKeys.display_if_loan_over].double
    if let items = json[SerializationKeys.display_if_job_type_is].array { displayIfJobTypeIs = items.map { $0.intValue } }
    self.displayIfNeedAdditionalMissingData = json[SerializationKeys.display_if_need_additional_missing_data].boolValue
    
    self.checkCanDisplay()
    
  }
    
    mutating func checkCanDisplay() {
        
        if let id_ = self.id, id_ == "optionalMedia" {
            if let amount = self.displayIfLoanOver, amount > Double(DataManager.shared.loanInfo.amount) {
                
                if let listJob = self.displayIfJobTypeIs, listJob.count > 0 {
                    let temp = listJob.filter { $0 == DataManager.shared.loanInfo.jobInfo.jobType }
                    if temp.count == 0 {
                        self.isCanDisplay = false
                        return
                    }
                }
            }
            
            if self.title == nil {
                //Check display when have missing Data
                self.isCanDisplay = false
                guard let data = DataManager.shared.missingLoanDataDictionary, let value = data["addtionalImage"] as? String else { return }
                self.isCanDisplay = true
                self.title = value
                
                return
            }
            
        }
        
        if let listJob = self.displayIfJobTypeIs, listJob.count > 0 {
            
            let temp = listJob.filter { $0 == DataManager.shared.loanInfo.jobInfo.jobType }
            if temp.count == 0 {
                self.isCanDisplay = false
                return
            }
            
        }
        
        self.isCanDisplay = true
    }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = suffix { dictionary[SerializationKeys.suffix] = value }
    if let value = data { dictionary[SerializationKeys.data] = value.map { $0.dictionaryRepresentation() } }
    if let value = selectorTitle { dictionary[SerializationKeys.selectorTitle] = value }
    dictionary[SerializationKeys.multipleLine] = multipleLine
    if let value = descriptionValue { dictionary[SerializationKeys.descriptionValue] = value }
    dictionary[SerializationKeys.showData] = showData
    if let value = type { dictionary[SerializationKeys.type] = value }
    if let value = multipleData { dictionary[SerializationKeys.multipleData] = value.map { $0.dictionaryRepresentation() } }
    if let value = index { dictionary[SerializationKeys.index] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    dictionary[SerializationKeys.isRequired] = isRequired
    if let value = title { dictionary[SerializationKeys.title] = value }
    if let value = placeholder { dictionary[SerializationKeys.placeholder] = value }
    if let value = keyboard { dictionary[SerializationKeys.keyboard] = value }
    dictionary[SerializationKeys.showTime] = showTime
    
    if let value = arrayIndex { dictionary[SerializationKeys.arrayIndex] = value }
    if let value = dataName { dictionary[SerializationKeys.dataName] = value }
    if let value = maxLenght { dictionary[SerializationKeys.maxLength] = value }
    
    return dictionary
  }

}
