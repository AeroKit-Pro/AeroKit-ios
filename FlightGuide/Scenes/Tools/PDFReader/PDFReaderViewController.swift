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
        let pdfView = PDFView()
        view.addSubview(pdfView)
        pdfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        pdfView.autoScales = true
        pdfView.document = PDFDocument(url: fileURL)
    }

}
