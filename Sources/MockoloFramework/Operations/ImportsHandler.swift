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

import Algorithms

func handleImports(pathToImportsMap: ImportMap,
                   customImports: [String]?,
                   publicCustomImports: [String]?,
                   excludeImports: [String]?,
                   testableImports: [String]?,
                   relevantPaths: [String]) -> String {

    var importLines = [String: [String]]()
    let defaultKey = ""
    if importLines[defaultKey] == nil {
        importLines[defaultKey] = []
    }

    for (path, importMap) in pathToImportsMap {
        guard relevantPaths.contains(path) else { continue }
        for (k, v) in importMap {
            if importLines[k] == nil {
                importLines[k] = []
            }

            if let ex = excludeImports {
                let filtered = v.filter{ !ex.contains($0.moduleNameInImport) }
                importLines[k]?.append(contentsOf: filtered)
            } else {
                importLines[k]?.append(contentsOf: v)
            }
        }
    }

    var sortedImports = [String: [String]]()
    
    // Process all imports for the default key (non-conditional imports)
    var moduleToEntry: [String: ImportEntry] = [:]
    
    // 1. Start with existing imports from source files
    if let existingImports = importLines[defaultKey] {
        for importLine in existingImports {
            let moduleName = importLine.bareModuleName
            let type = importLine.importType
            if !moduleName.isEmpty {
                moduleToEntry[moduleName] = ImportEntry(module: moduleName, type: type)
            }
        }
    }
    
    // 2. Add custom imports (replace if duplicate)
    if let customImports = customImports {
        for module in customImports {
            moduleToEntry[module] = ImportEntry(module: module, type: .regular)
        }
    }
    
    // 3. Add testable imports (replace if duplicate, higher precedence)
    if let testableImports = testableImports {
        for module in testableImports {
            if let existing = moduleToEntry[module] {
                if ImportType.testable.precedence > existing.type.precedence {
                    moduleToEntry[module] = ImportEntry(module: module, type: .testable)
                }
            } else {
                moduleToEntry[module] = ImportEntry(module: module, type: .testable)
            }
        }
    }
    
    // 4. Add public custom imports (replace if duplicate, highest precedence)
    if let publicCustomImports = publicCustomImports {
        for module in publicCustomImports {
            if let existing = moduleToEntry[module] {
                if ImportType.public.precedence > existing.type.precedence {
                    moduleToEntry[module] = ImportEntry(module: module, type: .public)
                }
            } else {
                moduleToEntry[module] = ImportEntry(module: module, type: .public)
            }
        }
    }
    
    // 5. Sort by bare module name and format
    let sortedEntries = moduleToEntry.values.sorted { $0.module < $1.module }
    sortedImports[defaultKey] = sortedEntries.map { $0.formattedImport }
    
    // Process conditional imports (keep existing logic for these)
    for (k, v) in importLines where k != defaultKey {
        sortedImports[k] = Set(v).sorted()
    }

    let sortedKeys = sortedImports.keys.sorted()
    let importsStr = sortedKeys.map { k in
        let v = sortedImports[k]
        let lines = v?.joined(separator: "\n") ?? ""
        if k.isEmpty {
            return lines
        } else {
            return """
            #if \(k)
            \(lines)
            #endif
            """
        }
    }.joined(separator: "\n")

    return importsStr
}
