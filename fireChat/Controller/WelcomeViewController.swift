//
//  ViewController.swift
//  fireChat
//
//  Created by Alijon Jumayev on 4/8/24.
//
import UIKit


class WelcomeViewController: UIViewController {
    
    private let background: UIImageView = {
        let background                                       = UIImageView()
        background.image                                     = UIImage(named: "7")
        background.translatesAutoresizingMaskIntoConstraints = false
        background.contentMode                               = .scaleAspectFill
        return background
    }()
    
    private let buttonLogin: UIButton = {
        let button = UIButton()
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor                                 = .white
        button.backgroundColor                           = .systemPink
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius                        = 25
        button.layer.shadowColor                         = UIColor.black.cgColor
        button.layer.shadowOffset                        = CGSize(width: 0, height: 10)
        button.layer.shadowOpacity                       = 1
        button.layer.shadowRadius                        = 5.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return button
    }()
    
    private let buttonRegister: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor                                 = .white
        button.backgroundColor                           = .systemPink
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius                        = 25
        button.layer.shadowColor                         = UIColor.black.cgColor
        button.layer.shadowOffset                        = CGSize(width: 0, height: 10)
        button.layer.shadowOpacity                       = 1
        button.layer.shadowRadius                        = 5.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return button
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font                = UIFont.boldSystemFont(ofSize: 35)
        label.textColor           = .black
        label.textAlignment       = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true

        [background,label,buttonLogin,buttonRegister] .forEach {view.addSubview($0)}
        
        buttonRegister.addTarget(self, action: #selector(setButtonRegister), for: .touchUpInside)
        buttonLogin.addTarget(self, action: #selector(setButtonLogin), for: .touchUpInside)
        
        label.text = ""
                var charIndex = 0.0
                let titleText = "Chatting With Friends"
                for letter in titleText {
                    Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { timer in
                        self.label.text?.append(letter)
                    }
                    charIndex += 1
                }
        
//MARK: - button layout
        buttonLogin.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 10, bottom: 10, right: 10), size:  .init(width: 0, height: 50))
        
        buttonRegister.anchor(top: nil, bottom: buttonLogin.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor , padding:  .init(top: 0, left: 10, bottom: 20, right: 10),size: .init(width: 0, height: 50))
        
//MARK: - background layout
        background.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
//MARK: - label layout
        
        label.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,padding: .init(top: 30, left: 10, bottom: 0, right: 10), size: .init(width: 0, height: 60))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    
        navigationController?.isNavigationBarHidden = false
    }


//MARK: - next navigationcontrollers
    
    @objc func setButtonRegister() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func setButtonLogin() {
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
        
        
 
        
    

}

