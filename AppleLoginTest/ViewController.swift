//
//  ViewController.swift
//  AppleLoginTest
//
//  Created by 김희중 on 2021/05/24.
//

import UIKit
import SnapKit
import AuthenticationServices

class ViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    let loginButton: ASAuthorizationAppleIDButton = {
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.addTarget(self, action: #selector(loginApple), for: .touchUpInside)
        return appleButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: "001522.db163d1102d74c1aa62c3c0211633077.0548") { credentialState, error in
            switch credentialState {
            case .authorized:
                print("authorized")
                break
            case .revoked:
                print("revoked")
                break
            case .notFound:
                print("notFound")
                break
            case .transferred:
                print("transferred")
                break
            default:
                break
            }
        }
    }

    @objc private func loginApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = credential.user
            let fullName = credential.fullName
            let email = credential.email
            
            print(userIdentifier, fullName, email)
        }
    }

}

