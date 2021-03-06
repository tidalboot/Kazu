//
//  CloudKitHandler.swift
//  Kazu
//
//  Created by Nick Jones on 03/04/2015.
//  Copyright (c) 2015 Nick Jones. All rights reserved.
//

import Foundation
import CloudKit

public class CloudKitHandler {
    
    var container: CKContainer? = nil
    var publicDatabase: CKDatabase? = nil
    public var currentUserID: String?
    
    public init () {
        container = CKContainer.defaultContainer()
        publicDatabase = container!.publicCloudDatabase
    }
    
    public func doesUserHaveiCloudAccount () -> Bool {
        let doesUserHaveiCloudAccount = NSFileManager.defaultManager().ubiquityIdentityToken
        
        if doesUserHaveiCloudAccount == nil {
            return false
        }
        else {
            return true
        }
    }

    public func getUserID () -> String {
        var userID : String!
        
        container!.fetchUserRecordIDWithCompletionHandler({
            recordID, error in
            let userIDToReturn = recordID!.recordName
            userID = userIDToReturn
        })
        return userID
    }
}