//
//  HttpEntry.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 8/3/22.
//

import Foundation

protocol HttpEntryDelegate : AnyObject {
    func didGetEntries(_ statusCode: Int, _ entries: [Entry])
    func didGetFilterEntries(_ statusCode: Int, _ entries: [Entry], _ filterIndex: Int, startDate: Date)
    func didAddEntry(_ statusCode: Int, _ entry: Entry)
    func didUpdateEntry(_ statusCode: Int, _ entry: Entry)
    func didGetRecentTags(_ statusCode: Int, _ tags: [Tag])
}

extension HttpEntryDelegate {
    func didGetEntries(_ statusCode: Int, _ entries: [Entry]) {}
    func didGetFilterEntries(_ statusCode: Int, _ entries: [Entry], _ filterIndex: Int, startDate: Date) {}
    func didAddEntry(_ statusCode: Int, _ entry: Entry) {}
    func didUpdateEntry(_ statusCode: Int, _ entry: Entry){}
    func didGetRecentTags(_ statusCode: Int, _ tags: [Tag]) {}
}

struct HttpEntry {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let dateFormatter = ISO8601DateFormatter()

    var delegate: HttpEntryDelegate?

    func getEntries() {
        if let url = URL(string: "\(Server.url)/user/entries") {
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
                    if let entries = decodeEntries(data) {
                        delegate?.didGetEntries(response.statusCode, entries)
                    }
                }
            }
            task.resume()
        }
    }
    
    func getFilterEntries(_ startDate: Date, _ filterIndex: Int) {
        let startDateToSec = Calendar.current.startOfDay(for: startDate).timeIntervalSince1970
        let oneDaySec = 24*60*60*1.0
        let endDateSec = {() -> Double in
            switch filterIndex {
//               day
            case 0:
                return startDateToSec + oneDaySec
//            week
            case 1:
                return startDateToSec + 7 * oneDaySec
//            month
            case 2:
                var dateComponents = DateComponents()
                dateComponents.month = 1
                var month = Calendar.current.date(byAdding: dateComponents, to: startDate) ?? Date()
                return month.timeIntervalSince1970
            default:
                return startDateToSec
            }
        }()
        
        if #available(iOS 15.0, *) {
            print(Date(timeIntervalSince1970: startDateToSec).formatted())
            print(Date(timeIntervalSince1970: endDateSec).formatted())
        }
        
        if let url = URL(string: "\(Server.url)/user/entries/filter?startDate=\(startDateToSec)&endDate=\(endDateSec)") {
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
                    if response.statusCode == 200 {
                        if let entries = decodeEntries(data) {
                            delegate?.didGetFilterEntries(response.statusCode, entries, filterIndex, startDate: startDate)
                        }
                    }
                }
            }
            task.resume()
        }
    }

    func postEntry(_ entry: Entry) {
        if let url = URL(string: "\(Server.url)/user/entries") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            if let token = modelStore.state.jwtToken {
                request.addValue(token.replacingOccurrences(of: "\"", with: ""), forHTTPHeaderField: "authorization")
            }
            let json = encodeEntry(entry)
            print("printing entry in httpEntry postEntry")
            if #available(iOS 15.0, *) {
                print(Date(timeIntervalSince1970: (entry.dateCreated)!).formatted())
                }
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.httpBody = json

            // this is asynchronous
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                if let response = response as? HTTPURLResponse, let data = data {
                    delegate?.didAddEntry(response.statusCode, decodeEntry(data)!)
                }
            }
            task.resume()
        }
    }
    
    func updateEntry (_ entry: Entry) {
        print("printing entry")
//        print(entry.id!)
        if let url = URL(string: "\(Server.url)/user/entries/\(entry.id!)") {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            if let token = modelStore.state.jwtToken {
                request.addValue(token.replacingOccurrences(of: "\"", with: ""), forHTTPHeaderField: "authorization")
            }
            print("HERE IN UPDATE ENTRY")
            print(entry)
            let json = encodeEntry(entry)
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.httpBody = json

            // this is asynchronous
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                print("printing response")
                print(response)
                if let response = response as? HTTPURLResponse, let data = data {
                    print("printing the data inside")
                    print(data)
                    delegate?.didUpdateEntry(response.statusCode, decodeEntry(data)!)
                }
            }
            task.resume()
        }
    }
    
    func getRecentTags() {
        if let url = URL(string: "\(Server.url)/user/tags/recent") {
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
                        print("Inside decode entries in get entries")
                        delegate?.didGetRecentTags(response.statusCode, tags)
                    }
                }
            }
            task.resume()
        }
    }

    func decodeEntries(_ data: Data) -> [Entry]? {
        var entriesList = [Entry]()
        
        do {
            let decodedData = try decoder.decode([EntryJson].self, from: data)
            decodedData.forEach({ entry in
                let entryTags = entry.tags.map({ (tag: TagJson) -> Tag in
                    Tag(name: tag.name)
                })
    
                do {
                    let note = try entry.note

                    entriesList.append(Entry(
                        id: entry._id,
                        dateCreated: entry.dateCreated,
                        time: formatter(dateStr: entry.time),
                        mood: entry.mood,
                        note: note,
                        tags: entryTags)
                    )
                } catch {
                    print(error)
                    entriesList.append(Entry(
                        id: entry._id,
                        dateCreated: entry.dateCreated,
                        time: formatter(dateStr: entry.time),
                        mood: entry.mood,
                        tags: entryTags)
                    )
                }
            })

            return entriesList
        } catch {
            print("error in decoding entries")
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
            print("error in decode tags in httpEntry")
            print(String(data: data, encoding: .utf8))
            return nil
        }
    }
    
    func encodeEntry(_ entry: Entry) -> Data? {
        encoder.dateEncodingStrategy = .iso8601

        do {
            return try encoder.encode(entry)
        } catch {
            print(error)
            return nil
        }
    }

    func decodeEntry(_ data: Data) -> Entry? {
        print("In decode entry")
        do {
            let decodedData = try decoder.decode(EntryJson.self, from: data)
            do {
                let note = try decodedData.note
                print("printing entry")
                if #available(iOS 15.0, *) {
                    print(Date(timeIntervalSince1970: (decodedData.dateCreated)).formatted())
                    }
                return Entry(
                    id: decodedData._id,
                    dateCreated: decodedData.dateCreated,
                    time: formatter(dateStr: decodedData.time),
                    mood: decodedData.mood,
                    note: decodedData.note,
                    tags: []
                )
            } catch {
                print("NO NOTE HERE")
                return Entry(
                    id: decodedData._id,
                    dateCreated: decodedData.dateCreated,
                    time: formatter(dateStr: decodedData.time),
                    mood: decodedData.mood,
                    tags: []
                )
            }
        } catch {
            print("Error in decode entry")
            print(error)
            print(String(data: data, encoding: .utf8))
            return nil
        }
    }
    
    func formatter(dateStr: String) -> Date {
        dateFormatter.formatOptions = [
            .withFullDate,
            .withTime,
            .withDashSeparatorInDate,
            .withColonSeparatorInTime
        ]
        return dateFormatter.date(from: dateStr) ?? Date()
    }
}
