//
//  PDFStorageService.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 17.06.23.
//

import Foundation

final class PDFStorageService {
    private let maxItemsCount = 2
    private let documentsDirectoryURL: URL
    private let storeQueue = DispatchQueue(label: "PDFStorageService.storeQueue", attributes: .concurrent)

    init() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access documents directory.")
        }
        self.documentsDirectoryURL = documentsDirectory.appendingPathComponent("pdfStorage")
        createDirectoryIfNeeded(at: self.documentsDirectoryURL)

    }

    private func createDirectoryIfNeeded(at url: URL) {
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            assertionFailure("Error creating directory: \(error.localizedDescription)")
        }
    }


    func storeData(with url: URL, completion: ((URL?) -> Void)?) {
        storeQueue.async(flags: .barrier) {
            do {
                guard url.startAccessingSecurityScopedResource() else { completion?(nil); return }

                let data = try Data(contentsOf: url)

                let newURL = self.documentsDirectoryURL.appendingPathComponent(url.lastPathComponent)

                if FileManager.default.fileExists(atPath: newURL.absoluteString) {
                    try FileManager.default.removeItem(at: newURL)
                }

                try data.write(to: newURL)
                url.stopAccessingSecurityScopedResource()
                completion?(newURL)
                return
            } catch {
                assertionFailure("Error storing url: \(error.localizedDescription)")
            }
            completion?(nil)
        }
    }

    func retrieveAllURLs(completion: (([URL]) -> Void)?) {
        storeQueue.async {
            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(at: self.documentsDirectoryURL, includingPropertiesForKeys: nil)
                    .filter { FileManager.default.fileExists(atPath: $0.path )}
                if fileURLs.count > self.maxItemsCount {
                    let sortedURLs = fileURLs.sorted(by: { firstUrl, secondUrl in

                        do {
                            let firstFileAttributes = try FileManager.default.attributesOfItem(atPath: firstUrl.path) as [FileAttributeKey:Any]
                            let firstCreationDate = firstFileAttributes[FileAttributeKey.creationDate] as? Date ?? Date()

                            let secondFileAttributes = try FileManager.default.attributesOfItem(atPath: secondUrl.path) as [FileAttributeKey:Any]
                            let secondCreationDate = secondFileAttributes[FileAttributeKey.creationDate] as? Date ?? Date()

                            return secondCreationDate < firstCreationDate

                        } catch let error {
                            assertionFailure("file not found: \(error.localizedDescription)")
                            return false
                        }
                    })

                    let validURLs = Array(sortedURLs.prefix(self.maxItemsCount))

                    let oldURLs = Array(sortedURLs.dropFirst(self.maxItemsCount))
                    oldURLs.forEach {
                        self.deleteItem(at: $0)
                    }
                    completion?(validURLs)
                    return
                }
                completion?(fileURLs)
                return
            } catch {
                assertionFailure("Error retrieving all models: \(error.localizedDescription)")
            }
            completion?([])
        }
    }


    private func deleteItem(at url: URL) {
        storeQueue.async(flags: .barrier) {
            guard FileManager.default.fileExists(atPath: url.path) else { return }
            
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                assertionFailure("Error retrieving all models: \(error.localizedDescription)")
            }
        }
    }
}
