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
    case unableToFetchOrDecodeFromCoreData = "Failed to fetch or decode items from Core Data"
    case unableToEncodeOrSavetoCoreData = "Failed to encode or save items"
    case entityNotFound = "Entity not found"
    case unableToDeleteItemsInCoreData = "Failed to delete"
    case unknownFirebaseStorageError = "Unknown error occurred"
    case unableToAccessDirectory = "Unable to access the Documents directory"
    case errorGettingData = "Unable to convert string to Data"
    case errorWritingToFile = "Error writing to file"
    case errorDeletingFile = "Can't delete the file"
}
