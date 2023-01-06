//
//  ContentView.swift
//  One Time
//
//  Created by Kilo Loco on 1/3/23.
//

import AWSCognitoAuthPlugin
import Amplify
import SwiftUI

struct ContentView: View {
    let username = "kiloloco"
    let email = "rekylelee@gmail.com"
    
    @State var status = ""
    @State var confirmSignUpCode = ""
    @State var challengeCode = ""
    
    var body: some View {
        VStack {
            Button("SIGN UP", action: signUp)
            TextField("CONFIRM SIGN UP CODE", text: $confirmSignUpCode)
            Button("CONFIRM SIGN UP", action: confirmSignUp)
            Button("SIGN IN", action: signIn)
            TextField("CHALLENGE CODE", text: $challengeCode)
            Button("CONFIRM SIGN IN", action: confirmSignIn)
        }
        .padding()
    }
    
    func signUp() {
        Task {
            do {
                let userAttributes = [AuthUserAttribute(.email, value: email)]
                let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
                let result = try await Amplify.Auth.signUp(
                    username: username,
                    password: UUID().uuidString,
                    options: options
                )
                print(result)
                
                if case let .confirmUser(deliveryDetails, _, userId) = result.nextStep {
                    print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId)))")
                } else {
                    print("Signup Complete")
                }
            } catch {
                print(error)
            }
        }
    }
    
    func confirmSignUp() {
        Task {
            do {
                let result = try await Amplify.Auth.confirmSignUp(
                    for: username,
                    confirmationCode: confirmSignUpCode
                )
                print("Confirm sign up result completed: \(result.isSignUpComplete)")
            } catch let error as AuthError {
                print("An error occurred while confirming sign up \(error)")
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    }
    
    func signIn() {
        Task {
            do {
                let options = AWSAuthSignInOptions(authFlowType: .customWithoutSRP)
                let result = try await Amplify.Auth.signIn(
                    username: username,
                    options: .init(pluginOptions: options)
                )
                print(result)
                if case .confirmSignInWithCustomChallenge(let info) = result.nextStep {
                    print("Enter custom challenge. Additional Info:", info ?? "N/A")
                } else {
                    print("Sign in succeeded")
                }
            } catch {
                print(error)
            }
        }
    }
    
    func confirmSignIn() {
        Task {
            do {
                let result = try await Amplify.Auth.confirmSignIn(challengeResponse: challengeCode)
                print(result)
            } catch {
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
