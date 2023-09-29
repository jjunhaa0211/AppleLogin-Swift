//
//  ViewController.swift
//  AppleLoginTest
//
//  Created by 박준하 on 2023/09/29.
//

import UIKit
import AuthenticationServices
import RxSwift
import SnapKit
import Then

class LoginViewController: UIViewController {
    
    let loginButton = UIButton().then {
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .white
        $0.setImage(UIImage(systemName: "applelogo"), for: .normal)
        $0.setTitle("Sign in with Apple", for: .normal)
        $0.setTitleColor(.label, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17.0)
        $0.imageView?.tintColor = .black
        $0.layer.borderWidth = 0.5
        $0.addTarget(self, action: #selector(tappedAppleLoginBtn), for: .touchUpInside)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
       layout()
    }

    private func layout(){
        [loginButton].forEach({view.addSubview($0)})
        
        self.loginButton.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview().inset(20.0)
        })
    }
    
    @objc func tappedAppleLoginBtn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authCodeString = String(data: authorizationCode, encoding: .utf8),
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                print("authorizationCode: \(authorizationCode)")
                print("identityToken: \(identityToken)")
                print("authCodeString: \(authCodeString)")
                print("identifyTokenString: \(identifyTokenString)")
            }
            
            print("useridentifier: \(userIdentifier)")
            print("fullName: \(String(describing: fullName))")
            print("email: \(String(describing: email))")
            
            let validVC = CViewController()
            validVC.modalPresentationStyle = .fullScreen
            present(validVC, animated: true, completion: nil)
            
        case let passwordCredential as ASPasswordCredential:
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("username: \(username)")
            print("password: \(password)")
            
        default:
            break
        }
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("login failed - \(error.localizedDescription)")
    }
}
