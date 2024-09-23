import SwiftUI

struct Object: Codable, Hashable {
  let objectID: Int
  let title: String
  let creditLine: String
  let objectURL: String
  let isPublicDomain: Bool
  let primaryImageSmall: String
}

struct ObjectIDs: Codable {
  let total: Int
  let objectIDs: [Int]
}

let baseURLString = "https://collectionapi.metmuseum.org/public/collection/v1/"
var urlComponents = URLComponents(
  string: baseURLString + "search")!
var baseParams = [
  "hasImages": "true"
]
urlComponents.setQueryItems(with: baseParams)
urlComponents.url
urlComponents.url?.absoluteString

let queryTerm = "rhino wolf"
urlComponents.queryItems! += [URLQueryItem(name: "q", value: queryTerm)]
urlComponents.queryItems
urlComponents.url?.absoluteString

let queryURL = urlComponents.url
let request = URLRequest(url: queryURL!)
let session = URLSession.shared
let decoder = JSONDecoder()
var objects: [Object] = []

Task {  
  let (data, response) = try await session.data(for: request)
  guard
    let response = response as? HTTPURLResponse,
    (200..<300).contains(response.statusCode)
  else {
    print(">>> response outside bounds")
    return
  }
  let objectIDs = try decoder.decode(ObjectIDs.self, from: data)
  objectIDs.objectIDs

  for objectID in objectIDs.objectIDs {
    let objectURLString = baseURLString + "/objects/\(objectID)"
    let objectURL = URL(string: objectURLString)
    let objectRequest = URLRequest(url: objectURL!)
    let (data, response) = try await session.data(for: objectRequest)
    guard
      let response = response as? HTTPURLResponse,
      (200..<300).contains(response.statusCode)
    else {
      print(">>> response outside bounds")
      return
    }
    let object = try decoder.decode(Object.self, from: data)
    objects.append(object)
  }
  objects
}
