import Foundation

enum FLCError: String, Error {
    case unableToFetchCategories = "Error fetching categories"
    case invalidEndpoint = "The Endpoint is wrong"
    case invalidResponce = "Invalid responce from the server"
    case invalidResponceString = "Invalid responce string"
    case invalidBubbleToken = "Bubble token is invalid or anaccessible"
    case decodingError = "Error decoding data"
    case unableToDownload = "Can't download data"
    case invalidData = "The data received from the server was invalid"
    case unableToGetDocuments = "This collection doesn't have documents"
    case castingError = "The value is not a string"
    case unableToFetchOrDecodeFromCoreData = "Failed to fetch or decode items from CoreData"
    case unableToEncodeOrSavetoCoreData = "Failed to encode or save items to CoreData"
    case entityNotFound = "Entity not found"
    case unableToSaveToUserDefaults = "Failed to save items to UserDefaults"
    case unableToUpdateUserDefaults = "Failed to update items in UserDefaults"
    case unableToRetrieveFromUserDefaults = "Failed to retrieve items from UserDefaults"
    case unableToDeleteItemsInCoreData = "Failed to delete in CoreData"
    case unknownFirebaseStorageError = "Unknown error occurred"
    case unableToAccessDirectory = "Unable to access the Documents directory"
    case errorGettingData = "Unable to convert string to Data"
    case errorWritingToFile = "Error writing to file"
    case errorDeletingFile = "Can't delete the file"
    case unableToFindContainerURL = "Could not find container URL for app group"
    case unableToFindAppDirectory = "Could not find application support directory"
    case unableToDecodeFromKeychain = "Fail to decode item from keychain"
    case unableToEncodeFromKeychain = "Fail to encode item for keychain"
}
