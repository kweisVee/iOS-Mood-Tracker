//
//  HttpTags.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 8/4/22.
//

import Foundation

protocol HttpTagsDelegate : AnyObject {
    func didAddAndUpdateTags(_ statusCode: Int, _ strData: String)
//    func didUpdateTags(_ statusCode: Int, _ strData: String)
    func didGetTags(_ statusCode: Int, _ tags: [Tag])
}

extension HttpTagsDelegate {
    func didAddAndUpdateTags(_ statusCode: Int, _ strData: String) {}
//    func didUpdateTags(_ statusCode: Int, _ strData: String) {}
    func didGetTags(_ statusCode: Int, _ tags: [Tag]) {}
}

struct HttpTags {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let dateFormatter = ISO8601DateFormatter()
    
    weak var delegate: HttpTagsDelegate?
    
    func addTags(_ tags: [TagJson], _ entryId: String) {
        if let url = URL(string: "\(Server.url)/user/entries/\(entryId)/tags") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let json = encodeTags(tags)
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            if let token = modelStore.state.jwtToken {
                request.addValue(token.replacingOccurrences(of: "\"", with: ""), forHTTPHeaderField: "authorization")
            }
            request.httpBody = json
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }

                if let response = response as? HTTPURLResponse, let data = data {
                    delegate?.didAddAndUpdateTags(response.statusCode, String(data: data, encoding: .utf8) ?? "")
                    print("Tags added")
                }
            }
            task.resume()
        }
    }
    
    func updateTags (_ tags: [TagJson], _ entryId: String) {
        if let url = URL(string: "\(Server.url)/user/entries/\(entryId)/tags") {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            let json = encodeTags(tags)
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            if let token = modelStore.state.jwtToken {
                request.addValue(token.replacingOccurrences(of: "\"", with: ""), forHTTPHeaderField: "authorization")
            }
            request.httpBody = json
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }

                if let response = response as? HTTPURLResponse, let data = data {
                    delegate?.didAddAndUpdateTags(response.statusCode, String(data: data, encoding: .utf8) ?? "")
                    print("Tags updated")
                }
            }
            task.resume()
        }
    }
    
    func getTags() {
        if let url = URL(string: "\(Server.url)/user/tags") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            if let token = modelStore.state.jwtToken {
                request.addValue(token.replacingOccurrences(of: "\"", with: ""), forHTTPHeaderField: "authorization")
            }
            // this is asynchronous
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                if let response = response as? HTTPURLResponse, let data = data {
                    if let tags = decodeTags(data) {
                        delegate?.didGetTags(response.statusCode, tags)
                    }
                }
            }
            task.resume()
        }
    }    
    
    func encodeTags(_ tags: [TagJson]) -> Data? {
        do {
            return try encoder.encode(tags)
        } catch {
            print(error)
            return nil
        }
    }
    
    func decodeTags(_ data: Data) -> [Tag]? {
        var tagList = [Tag]()

        do {
            let decodedData = try decoder.decode([TagArrayJson].self, from: data)
            decodedData.forEach({ tag in
                do {
                    tagList.append(Tag(name: tag._id))
                } catch {
                    print("Error in appending to recent tag list")
                }
            })
            return tagList
        } catch {
            print("error in decode tags")
            print(String(data: data, encoding: .utf8))
            return nil
        }
    }
}
