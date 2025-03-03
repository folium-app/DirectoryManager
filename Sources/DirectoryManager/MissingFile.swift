//
//  File.swift
//  DirectoryManager
//
//  Created by Jarrod Norwell on 6/12/2024.
//

import Foundation
import UIKit

public struct MissingFile : Codable, Hashable, @unchecked Sendable {
    public enum Importance : Int, Codable, Hashable, @unchecked Sendable {
        case optional, required
        
        public var color: UIColor {
            switch self {
            case .optional:
                .systemOrange
            case .required:
                .systemRed
            }
        }
        
        public var string: String {
            switch self {
            case .optional:
                "Optional"
            case .required:
                "Required"
            }
        }
    }
    
    public var details: String? = nil
    public let core, `extension`: String
    public let importance: Importance
    public let isSystemFile: Bool
    public let name, nameWithoutExtension: String
    
    public func `import`(from url: URL) throws {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        if #available(iOS 16, *) {
            try FileManager.default.copyItem(at: url, to: documentDirectory
                .appending(path: core)
                .appending(path: "sysdata")
                .appending(component: name))
        } else {
            try FileManager.default.copyItem(at: url, to: documentDirectory
                .appendingPathComponent(core, conformingTo: .folder)
                .appendingPathComponent("sysdata", conformingTo: .folder)
                .appendingPathComponent(name, conformingTo: .fileURL))
        }
    }
}
