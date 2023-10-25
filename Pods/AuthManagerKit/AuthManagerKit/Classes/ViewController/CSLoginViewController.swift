//
//  CSLoginViewController.swift
//  AuthManagerKit
//
//  Created by li on 5/11/23.
//

import Foundation
import CSBaseView
import AuthenticationServices

public typealias AuthFinished = (_ authModel:AuthUserModel) -> Void
public class CSLoginViewController: BaseViewController {
    public var authFinished:AuthFinished?
    public override func viewDidLoad() {
        super.viewDidLoad();
        let welcomeView = CSBaseWelcomeView.init(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.height),paramsDict: .init());
        welcomeView.appleLoginHandler = {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
            
        }
        welcomeView.discordLoginHandler = {
            let clientID = "1108310949703725068"
            let redirect = "http://localhost:50451/api/discord/callback"

            let url = String(format: "https://discordapp.com/api/oauth2/authorize?client_id=%@&scope=identify&response_type=code&redirect_uri=%", clientID, redirect);
            
            let rootVc = CSBaseWebViewController(webUrl: url)
            let nav = BaseNavigationController(rootViewController: rootVc)
            self.present(nav, animated: true)
        }
        welcomeView.startHandler = {
            var dict:Dictionary<String, Any> = .init()
            dict["enter_from"] = "signin"
            let phoneVC = CSLoginPhoneViewController(authViewStyle: .authViewStylePhoneNumber, paramsDict: dict, authFinished: self.authFinished)
            self.navigationController?.pushViewController(phoneVC, animated: true)
        }
        welcomeView.signUpHandler = {
            var dict:Dictionary<String ,Any> = .init()
            dict["enter_from"] = "signup"
            let phoneVc = CSLoginPhoneViewController(authViewStyle: .authViewStylePhoneNumber, paramsDict: dict, authFinished: self.authFinished)
            self.navigationController?.pushViewController(phoneVc, animated: true)
        }
        self.view.addSubview(welcomeView)
    }
}

extension CSLoginViewController: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            NSLog("email = %@", email ?? "")
            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
            self.saveUserInKeychain(userIdentifier)
            
            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
            self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
        
        case let passwordCredential as ASPasswordCredential:
        
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            NSLog("email = %@", username ?? "")

            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
    }
    
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.example.apple-samplecode.CS", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
    private func showResultViewController(userIdentifier: String, fullName: PersonNameComponents?, email: String?) {
        
        
    }
    
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// - Tag: did_complete_error
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

extension CSLoginViewController: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

