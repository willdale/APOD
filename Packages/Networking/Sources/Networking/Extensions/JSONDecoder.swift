import Foundation
import Library

extension JSONDecoder {
    static let `default` = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(.year)
        return decoder
    }()
}
