
import UIKit


class CustomView: UIView {
    
   lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    lazy var messageLabel: UILabel = UILabelFactory.createUILabel(textStyle: UIFont.systemFont(ofSize: 16, weight: .medium), alignment: .center, numberOfLines: 0)
    
    
    convenience init(frame: CGRect, message: String = "No record found") {
        self.init(frame: frame)
        messageLabel.text = message
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    private func commonInit() {
        setupView()
        setupConstainers()
    }
    
    private func setupView() {
        self.addSubview(containerView)
        containerView.addSubview(messageLabel)
    }
    
    private func setupConstainers() {
        
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        messageLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        messageLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -20).isActive = true
        
        self.layoutIfNeeded()
    }
}

