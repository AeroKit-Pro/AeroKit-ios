//
//  AuthorizationService.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 6.07.23.
//

import AuthenticationServices
import CryptoKit
import FirebaseAuth
import UIKit

final class AppleAuthorizationService: NSObject {
    private var currentNonce: String?
    var completion: ((Error?) -> Void)?

    func performSignInWithApple(contextProvider: ASAuthorizationControllerPresentationContextProviding) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        self.currentNonce = randomNonceString()
        request.nonce = sha256(currentNonce!)

        // Present Apple authorization form
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = contextProvider
        authorizationController.performRequests()
    }
}


// MARK: Sign in with Apple
extension AppleAuthorizationService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion?(error)
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

            guard let nonce = currentNonce,
                  let appleIDToken = appleIDCredential.identityToken,
                  let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                completion?(NSError(domain: "", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Something wrong"]))
                return
            }

            let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                              idToken: idTokenString,
                                                              rawNonce: nonce)
            Auth.auth().signIn(with: firebaseCredential) { [weak self] (authResult, error) in
                if let error = error {
                    self?.completion?(error)
                    return
                }

                let changeRequest = authResult?.user.createProfileChangeRequest()
                changeRequest?.displayName = appleIDCredential.fullName?.givenName
                changeRequest?.commitChanges(completion: { (error) in

                    if let error = error {
                        self?.completion?(error)
                    } else {
                        self?.completion?(nil)
                    }
                })
            }
       }

    }
}
extension AppleAuthorizationService {
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }

}
