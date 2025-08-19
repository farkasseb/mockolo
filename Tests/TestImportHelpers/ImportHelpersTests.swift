import XCTest
import MockoloFramework

class ImportHelpersTests: MockoloTestCase {
    
    // MARK: - bareModuleName tests
    
    func testBareModuleNameRegularImport() {
        let importStatement = "import Foundation"
        XCTAssertEqual(importStatement.bareModuleName, "Foundation")
    }
    
    func testBareModuleNameTestableImport() {
        let importStatement = "@testable import MyModule"
        XCTAssertEqual(importStatement.bareModuleName, "MyModule")
    }
    
    func testBareModuleNamePublicImport() {
        let importStatement = "public import SharedFramework"
        XCTAssertEqual(importStatement.bareModuleName, "SharedFramework")
    }
    
    func testBareModuleNameWithWhitespace() {
        let importStatement = "  import   Foundation  "
        XCTAssertEqual(importStatement.bareModuleName, "Foundation")
    }
    
    func testBareModuleNameInvalidImport() {
        let invalidStatement = "not an import"
        XCTAssertEqual(invalidStatement.bareModuleName, "")
    }
    
    func testBareModuleNameEmptyString() {
        let emptyStatement = ""
        XCTAssertEqual(emptyStatement.bareModuleName, "")
    }
    
    // MARK: - importType tests
    
    func testImportTypeRegular() {
        let importStatement = "import Foundation"
        XCTAssertEqual(importStatement.importType, .regular)
    }
    
    func testImportTypeTestable() {
        let importStatement = "@testable import MyModule"
        XCTAssertEqual(importStatement.importType, .testable)
    }
    
    func testImportTypePublic() {
        let importStatement = "public import SharedFramework"
        XCTAssertEqual(importStatement.importType, .public)
    }
    
    func testImportTypeWithWhitespace() {
        let importStatement = "  @testable import   MyModule  "
        XCTAssertEqual(importStatement.importType, .testable)
    }
    
    func testImportTypeInvalid() {
        let invalidStatement = "not an import"
        XCTAssertEqual(invalidStatement.importType, .regular)
    }
    
    // MARK: - ImportEntry.formattedImport tests
    
    func testImportEntryFormattedImportBehavior() {
        let regularEntry = ImportEntry(module: "Foundation", type: .regular)
        XCTAssertEqual(regularEntry.formattedImport, "import Foundation")
        
        let testableEntry = ImportEntry(module: "MyModule", type: .testable)
        XCTAssertEqual(testableEntry.formattedImport, "@testable import MyModule")
        
        let publicEntry = ImportEntry(module: "SharedFramework", type: .public)
        XCTAssertEqual(publicEntry.formattedImport, "public import SharedFramework")
    }
    
    // MARK: - ImportType precedence tests
    
    func testImportTypePrecedence() {
        XCTAssertEqual(ImportType.regular.precedence, 1)
        XCTAssertEqual(ImportType.testable.precedence, 2)
        XCTAssertEqual(ImportType.public.precedence, 3)
        
        XCTAssertTrue(ImportType.public.precedence > ImportType.testable.precedence)
        XCTAssertTrue(ImportType.testable.precedence > ImportType.regular.precedence)
    }
    
    // MARK: - ImportEntry tests
    
    func testImportEntryFormattedImportRegular() {
        let entry = ImportEntry(module: "Foundation", type: .regular)
        XCTAssertEqual(entry.formattedImport, "import Foundation")
    }
    
    func testImportEntryFormattedImportTestable() {
        let entry = ImportEntry(module: "MyModule", type: .testable)
        XCTAssertEqual(entry.formattedImport, "@testable import MyModule")
    }
    
    func testImportEntryFormattedImportPublic() {
        let entry = ImportEntry(module: "SharedFramework", type: .public)
        XCTAssertEqual(entry.formattedImport, "public import SharedFramework")
    }
    
    // MARK: - Edge case tests
    
    func testComplexModuleNames() {
        let importStatement = "import Swift.Collections"
        XCTAssertEqual(importStatement.bareModuleName, "Swift.Collections")
        XCTAssertEqual(importStatement.importType, .regular)
    }
    
    func testModuleNameWithNumbers() {
        let importStatement = "public import Module2"
        XCTAssertEqual(importStatement.bareModuleName, "Module2")
        XCTAssertEqual(importStatement.importType, .public)
    }
}