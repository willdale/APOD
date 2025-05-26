import Foundation

public enum NetowrkingError: LocalizedError, CustomStringConvertible {
    case noNetworkingManager
    case couldNotCreateURLRequest
    
    public var errorDescription: String? {
        switch self {
        case .couldNotCreateURLRequest: "Could not create URL Request"
        case .noNetworkingManager: "No networking manager"
        }
    }
    
    public var description: String {
        switch self {
        case .couldNotCreateURLRequest: "couldNotCreateURLRequest"
        case .noNetworkingManager: "noNetworkingManager"
        }
    }
}
