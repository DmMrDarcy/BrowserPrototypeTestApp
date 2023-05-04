//
//  ViewController.swift
//  BrowserPrototypeTestApp
//
//  Created by Dmitriy Lukyanov on 03.05.2023.
//

import UIKit
import WebKit
import Combine

class MainViewController: UIViewController, Coordinating {
    
    var coordinator: Coordinator?
    private let container: DIContainer
    private var cancelBag = CancelBag()
    
    init(container: DIContainer, coordinator: Coordinator? = nil) {
        self.container = container
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let historyBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let searchField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Enter URL here..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loader: UIProgressView = {
        let loader = UIProgressView(progressViewStyle: .bar)
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        searchField.delegate = self
        webView.navigationDelegate = self
        
        container.appState.map(\.selectedUrl)
            .removeDuplicates()
            .dropFirst()
            .sink { value in
                if let url = URL(string: value),
                   isValidUrl(urlString: value) {
                    let request = URLRequest(url: url)
                    self.webView.load(request)
                }
            }
            .store(in: cancelBag)
        
        historyBtn.addTarget(self, action: #selector(historyBtnPressed), for: .touchUpInside)
    }
    
    @objc func historyBtnPressed() {
        coordinator?.eventOccured(with: .goToHistoryVC)
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text,
            let url = URL(string: text),
            isValidUrl(urlString: text) {
            let request = URLRequest(url: url)
            webView.load(request)
            errorLabel.text = ""
            textField.text = ""
            loader.setProgress(0.1, animated: true)
        } else {
            errorLabel.text = "Incorrect url"
            textField.text = ""
            webView.loadHTMLString("", baseURL: nil)
        }
        
        textField.resignFirstResponder()
        return true
    }
}

extension MainViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        loader.setProgress(1.0, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.loader.isHidden = true
            self.loader.setProgress(0.0, animated: false)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation, withError error: Error) {
        loader.setProgress(0.0, animated: true)
        errorLabel.text = "Page load error"
        webView.loadHTMLString("", baseURL: nil)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation) {
        loader.isHidden = false
        
        if let url = webView.url,
           isValidUrl(urlString: url.description) {
            container.appState[\.historyState].append(url.description)
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation) {
        loader.isHidden = false
        loader.setProgress(0.1, animated: true)
    }
}

extension MainViewController {
    func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(webView)
        view.addSubview(historyBtn)
        view.addSubview(searchField)
        view.addSubview(errorLabel)
        view.addSubview(loader)
        
        NSLayoutConstraint.activate([
            historyBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            historyBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            historyBtn.widthAnchor.constraint(equalToConstant: 28),
            historyBtn.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            searchField.trailingAnchor.constraint(equalTo: historyBtn.leadingAnchor, constant: -8),
            searchField.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 8),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 8),
            errorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loader.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 8)
        ])
    }
}
