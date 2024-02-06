//
//  ViewController.swift
//  UIKitMaraphone2
//
//  Created by Анас Бен Мустафа on 04.02.2024.
//

import UIKit

class Button: UIButton {

    private var animator: UIViewPropertyAnimator?
    private let title: String
    private let action: (() -> ())?
    
    init(
        title: String,
        action: (() -> ())? = nil
    ) {
        self.title = title
        self.action = action
        
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        if tintAdjustmentMode == .dimmed {
            backgroundColor = .systemGray2
            tintColor = .systemGray3
        } else {
            backgroundColor = .systemBlue
            tintColor = .white
        }
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        setImage(
            UIImage(systemName: "paperplane.fill")?.withRenderingMode(.alwaysTemplate),
            for: .highlighted
        )
        setImage(
            UIImage(systemName: "paperplane.fill")?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        semanticContentAttribute = .forceRightToLeft
        backgroundColor = .systemBlue
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
        tintColor = .white
        layer.cornerRadius = 8
        addTarget(self, action: #selector(onTouchDown), for: .touchDown)
        addTarget(self, action: #selector(onTouchUpInside), for: .touchUpInside)
    }
    
    @objc private func onTouchDown() {
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        animator?.startAnimation()
    }
    
    @objc private func onTouchUpInside() {
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut) {
            self.transform = .identity
        }
        animator?.startAnimation()
        action?()
    }
    
}

class ViewController: UIViewController {

    let button1 = Button(title: "First button")
    let button2 = Button(title: "Second medium button")
    lazy var button3: Button = {
        let button = Button(
            title: "Third",
            action: { [unowned self] in
                let vc = UIViewController()
                vc.view.backgroundColor = .white
                self.present(vc, animated: true)
            }
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        
        setupConstraints()
    }

    private func setupConstraints() {
        let button2LeadingAnchor = button2.leadingAnchor.constraint(lessThanOrEqualTo: view.leadingAnchor, constant: 8)
        let button2TrailingAnchor = button2.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: 0)
        button2LeadingAnchor.priority = .defaultLow
        button2TrailingAnchor.priority = .defaultLow
        NSLayoutConstraint.activate([
            button1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            button1.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 1),
            button1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 8),
            button2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button2.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 1),
            
            button3.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 8),
            button3.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 1),
            button3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

}
