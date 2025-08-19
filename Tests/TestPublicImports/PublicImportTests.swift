import Foundation

class PublicImportTests: MockoloTestCase {
    func testPublicCustomImports() {
        verify(srcContent: basicProtocol,
               dstContent: basicProtocolMockWithPublicImports,
               publicCustomImports: ["Foundation", "Combine"])
    }
    
    func testPublicImportConflictResolution() {
        verify(srcContent: protocolWithImports,
               dstContent: protocolWithImportsAndPublicOverrides,
               testableImports: ["Foundation"],
               publicCustomImports: ["Foundation", "UIKit"])
    }
    
    func testAlphabeticalSortingWithPublicImports() {
        verify(srcContent: protocolWithMixedImports,
               dstContent: sortedImportsOutput,
               testableImports: ["Alpha", "Delta"],
               publicCustomImports: ["Beta", "Foxtrot"])
    }
    
    func testPublicImportFromSourcePreservation() {
        verify(srcContent: sourceWithPublicImport,
               dstContent: mockWithPreservedPublicImport)
    }
}