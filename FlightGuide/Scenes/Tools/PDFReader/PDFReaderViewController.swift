//
//  PDFReaderViewController.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 1.06.23.
//

import QuickLook

final class PDFReaderViewController: UIViewController {

    private let fileURL: URL
    init(fileURL: URL) {
        self.fileURL = fileURL
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        previewController.dataSource = self

        // Add PDFView to view controller.
        let pdfView = PDFView()
        view.addSubview(pdfView)
        pdfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        pdfView.autoScales = true
        pdfView.document = PDFDocument(url: fileURL)
    }

}
//extension PDFReaderViewController: QLPreviewControllerDataSource {
////    var selectedFileURL: URL?
////
////    init(selectedFileURL: URL? = nil) {
////        self.selectedFileURL = selectedFileURL
////        super.init(nibName: nil, bundle: nil)
////    }
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////    }
//
//    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
//        fileURL != nil ? 1 : 0
//    }
//
//    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
//        fileURL! as QLPreviewItem
//    }
//}
