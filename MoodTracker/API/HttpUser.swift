//
//  HttpUser.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 8/3/22.
//

import Foundation

protocol HttpUserDelegate : AnyObject {
    func didRegister(_ statusCode: Int, _ strData: String)
    func didLogin(_ statusCode: Int, _ strData: String)
    func didLogoutAndDelete(_ statusCode: Int)
    func didGetUser(_ statusCode: Int, _ username: Username)
}

extension HttpUserDelegate {
    func didRegister(_ statusCode: Int, _ strData: String) {}
    func didLogin(_ statusCode: Int, _ strData: String) {}
    func didLogoutAndDelete(_ statusCode: Int) {}
    func didGetUser(_ statusCode: Int, _ username: Username) {}
}

struct HttpUser {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    weak var delegate: HttpUserDelegate?
    
    func registerUser(_ user: User) {
        if let url = URL(string: "\(Server.url)/user") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let json = encodeUser(user)
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.httpBody = json
            
            //async
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                print("printing response")
                print(response)
                if let response = response as? HTTPURLResponse, let data = data {
                    delegate?.didRegister(response.statusCode, String(data: data, encoding: .utf8) ?? "")
                }
            }
            task.resume()
        }
    }
    
    func signInUser(_ login: Login) {
        if let url = URL(string: "\(Server.url)/user/login") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let json = encodeLogin(login)
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.httpBody = json
            
            //async
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    delegate?.didLogin(response.statusCode, String(data: data, encoding: .utf8) ?? "")
                }
            }
            task.resume()
        }
    }
    
    func getUser() {
        if let url = URL(string: "\(Server.url)/user") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            if let token = modelStore.state.jwtToken {
                request.addValue(token.replacingOccurrences(of: "\"", with: ""), forHTTPHeaderField: "authorization")
            }
            
            //async
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                print("printing response of get user")
                print(response)
                if let response = response as? HTTPURLResponse, let data = data {
                    if(response.statusCode == 200) {
                        delegate?.didGetUser(response.statusCode, decodeUser(data)!)
                    }
                }
            }
            task.resume()
        }
    }

    func deleteUser() {
        if let url = URL(string: "\(Server.url)/user") {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            if let token = modelStore.state.jwtToken {
                request.addValue(token.replacingOccurrences(of: "\"", with: ""), forHTTPHeaderField: "authorization")
            }
            
            //async
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    delegate?.didLogoutAndDelete(response.statusCode)
                }
            }
            task.resume()
        }
    }
    
    func logoutUser() {
        if let url = URL(string: "\(Server.url)/user/logout") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            if let token = modelStore.state.jwtToken {
                request.addValue(token.replacingOccurrences(of: "\"", with: ""), forHTTPHeaderField: "authorization")
            }
            
            //async
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    delegate?.didLogoutAndDelete(response.statusCode)
                }
            }
            task.resume()
        }
    }
    
    func encodeUser(_ user: User) -> Data? {
        do {
            return try encoder.encode(user)
        } catch {
            print(error)
            return nil
        }
    }
    
    func encodeLogin(_ login: Login) -> Data? {
        do {
            return try encoder.encode(login)
        } catch {
            print(error)
            return nil
        }
    }
    
    func decodeUser(_ data: Data) -> Username? {
        print("In decode user");
        do {
            let decodedData = try decoder.decode(UserJson.self, from: data)
            do {
                return Username(username: decodedData.name)
            } catch {
                print("Error in decodedData in decodeUser")
                print(error)
            }
        } catch {
            print("Error in decode user")
            print(error)
            return nil
        }
    }
}
