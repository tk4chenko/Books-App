//
//  WebViewController.swift
//  Books
//
//  Created by Artem Tkachenko on 10.07.2023.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    private lazy var webView = makeWebView()
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    private func setupUI() {
        hidesBottomBarWhenPushed = true
        view.addSubview(webView)
        webView.frame = view.bounds
        Task(priority: .userInitiated) {
            await getData()
        }
    }
    private func makeWebView() -> WKWebView {
        let preferenses = WKWebpagePreferences()
        preferenses.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = preferenses
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }
    private func getData() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            webView.load(data, mimeType: "text/html", characterEncodingName: "utf-8", baseURL: url)
        } catch {
            print(error.localizedDescription)
        }
    }
}
