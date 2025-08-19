//
//  Copyright (c) 2018. Uber Technologies
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

public enum ImportType {
    case regular
    case testable
    case `public`
    
    public var precedence: Int {
        switch self {
        case .public: 3    // Highest precedence
        case .testable: 2
        case .regular: 1
        }
    }
    
}

public struct ImportEntry {
    public let module: String
    public let type: ImportType
    
    public init(module: String, type: ImportType) {
        self.module = module
        self.type = type
    }
    
    public var formattedImport: String {
        switch type {
        case .regular: module.asImport
        case .testable: module.asTestableImport
        case .public: module.asPublicImport
        }
    }
}