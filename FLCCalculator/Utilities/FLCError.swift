import Foundation

enum FLCError: String, Error {
    case unableToFetchCategories = "Error fetching categories"
    case invalidEndpoint = "The Endpoint is wrong"
    case invalidResponce = "Invalid responce from the server"
    case decodingError = "Error decoding data"
}
