import Foundation

public struct APODResponse: Decodable, Sendable {
    public let title: String
    public let explanation: String
    public let date: Date
    public let url: URL
    public let hdurl: URL?
    public let mediaType: String
    public let serviceVersion: String
    public let copyright: String?
}
