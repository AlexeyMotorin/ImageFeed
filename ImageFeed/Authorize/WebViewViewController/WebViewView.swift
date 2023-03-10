import UIKit
import WebKit

protocol WebViewViewProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHiden(_ isHidden: Bool)
}

/// Вью экрана WebViewViewController
final class WebViewView: UIView {

    // MARK: - Public property
    var presenter: WebViewPresenterProtocol?
    weak var viewController: WebViewViewControllerProtocol!
    
    // MARK: - Private property
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
    init(frame: CGRect, viewController: WebViewViewControllerProtocol) {
        super.init(frame: frame)
        self.backgroundColor = .ypWhite
        self.translatesAutoresizingMaskIntoConstraints = false
        addSabViews()
        activateConstraint()
        
        self.viewController = viewController
        let authHelper = AuthHelper()
        self.presenter = WebViewPresenter(helper: authHelper)
        presenter?.view = self
        presenter?.viewDidLoad()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.presenter?.didUpdateProgressValue(self.webView.estimatedProgress)
             })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    private func addSabViews() {
        addSubviews(webView, backButton, progressView)
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

extension WebViewView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let code = code(from: navigationAction) {
            viewController?.getCode(code: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    /// Передаем презентору url для получения кода
    /// - Parameter navigationAction: из параметра получаем URL
    /// - Returns: Возврщаем код для дальнейшей работы с API
    private func code(from navigationAction: WKNavigationAction) -> String? {
        guard let url = navigationAction.request.url else { return nil}
        let code = presenter?.code(from: url)
        return code
    }
}

extension WebViewView: WebViewViewProtocol {
    func load(request: URLRequest) {
        webView.load(request)
        webView.navigationDelegate = self
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHiden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
}
