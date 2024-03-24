import Foundation

enum FLCError: String, Error {
    case unableToFetchCategories = "Error fetching categories"
    case invalidEndpoint = "The Endpoint is wrong"
    case invalidResponce = "Invalid responce from the server"
    case decodingError = "Error decoding data"
    case unableToDownload = "Can't download data"
    case invalidData = "The data received from the server was invalid"
    case unableToGetDocuments = "This collection doesn't have documents"
    case castingError = "The value is not a string"
    case unableToSaveTariffs = "There was an error saving the tariffs"
    case unableToRetrieveTariffs = "There was an error retrieving the tariffs"
}
