import UIKit
import WebKit

final class WebViewControllerScreen: UIView {
    
    weak var viewController: WebViewViewControllerProtocol?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - UI object
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .ypWhite
        return webView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "blackBackward"), for: .normal)
        button.tintColor = .ypBlack
        button.addTarget(self, action: #selector(didBackButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .ypBlack
        progressView.trackTintColor = .ypWhite
        return progressView
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .ypWhite
        self.translatesAutoresizingMaskIntoConstraints = false
        addSabViews()
        activateConstraint()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.viewController?.presenter?.didUpdateProgressValue(self.webView.estimatedProgress)
             })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewController: WebViewViewControllerProtocol) {
        self.init()
        self.viewController = viewController
    }
    
    // MARK: - Public methods
    func loadWebview(request: URLRequest) {
        webView.load(request)
        webView.navigationDelegate = self
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    // MARK: - Private methods
    func addSabViews() {
        addSubviews(webView, backButton, progressView)
    }
    
    func setProgressHiden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    private func activateConstraint() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 54),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressView.topAnchor.constraint(equalTo: backButton.topAnchor)
        ])
    }

    @objc private func didBackButtonTapped() {
        viewController?.dismissViewController()
    }
}

extension WebViewControllerScreen: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let code = code(from: navigationAction) {
            viewController?.getCode(code: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    /// Фунция получения кода для авторизации
    /// - Parameter navigationAction: navigationAction который получаем из метода (_ webView: , decidePolicyFor : , decisionHandler: ), получаем из него url, который разбираем на компоненты
    /// - Returns: нужный код для авторизации пользователя
    private func code(from navigationAction: WKNavigationAction) -> String? {
        guard let url = navigationAction.request.url else { return nil}
        let code = viewController?.presenter?.code(from: url)
        return code
    }
}
