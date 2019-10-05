//
//  FileHandler.swift
//  My Properties
//
//  Created by Yosi Mizrachi on 02/06/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import UIKit

protocol FileHandler {
    
}

extension FileHandler {
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileForName(name: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(name)
    }
    
    func saveImageFile(data: Data?, withName: String){
        if let data = data {
            try? data.write(to: getFileForName(name: withName))
        }
    }
}

