//
//  APIKey.swift
//  Kebuke
//
//  Created by Labe on 2024/8/23.
//

import Foundation
import UniformTypeIdentifiers

enum APIKey {
    struct ApiKeyData: Decodable {
        let apiKey: String
    }
    
    static var `default`: String {
        guard let fileURL = Bundle.main.url(forResource: "\(Self.self)", withExtension: UTType.propertyList.preferredFilenameExtension) else {
            fatalError("Couldn't find file APIKey.plist")
        }
        guard let data = try? Data(contentsOf: fileURL) else {
            fatalError("Couldn't read data from APIKey.plist")
        }
        guard let apiKey = try? PropertyListDecoder().decode(ApiKeyData.self, from: data).apiKey else {
            fatalError("Couldn't find key apiKey")
        }
        return apiKey
    }
}
