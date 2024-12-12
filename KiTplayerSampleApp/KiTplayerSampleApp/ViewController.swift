//
//  ViewController.swift
//  KiTplayerSampleApp
//
//  Created by Jaeyoung Lee on 12/12/24.
//

import UIKit
import KiTplayerSDK

class ViewController: UIViewController {
    private let buttonDefault: UIButton = {
        let button = UIButton()
        button.setTitle("Default", for: .normal)
        button.tag = 0
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 28
        return button
    }()
    private let buttonEmbeded: UIButton = {
        let button = UIButton()
        button.setTitle("Embeded", for: .normal)
        button.tag = 1
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 28
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBlue
        
        setupButtons()

        KiTplayer.shared.addListenerDelegate(self)
    }
}

extension ViewController {
    private func setupButtons() {
        view.addSubview(buttonDefault)
        view.addSubview(buttonEmbeded)
        
        buttonDefault.translatesAutoresizingMaskIntoConstraints = false
        buttonEmbeded.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonDefault.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            buttonDefault.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            buttonDefault.widthAnchor.constraint(equalToConstant: 120),
            buttonDefault.heightAnchor.constraint(equalToConstant: 56),
            
            buttonEmbeded.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            buttonEmbeded.bottomAnchor.constraint(equalTo: buttonDefault.topAnchor, constant: -24),
            buttonEmbeded.widthAnchor.constraint(equalToConstant: 120),
            buttonEmbeded.heightAnchor.constraint(equalToConstant: 56),
        ])
        
        buttonDefault.addTarget(self, action: #selector(handleClick), for: .touchUpInside)
        buttonEmbeded.addTarget(self, action: #selector(handleClick), for: .touchUpInside)
    }
    
    @objc func handleClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            KiTplayer.shared.start()
        case 1:
            KiTplayer.shared.start(with: .embeded)
        default:
            break
        }
    }
}

extension ViewController: KiTPlayerListenerDelegate {
    func didOccurError(_ errorCode: KiTplayerSDK.KiTplayerErrorCode) {
        print("🚨", errorCode)
    }
}
