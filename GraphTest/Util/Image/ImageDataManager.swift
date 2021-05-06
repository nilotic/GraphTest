import SwiftUI
import Combine

final class ImageDataManager {
    
    // MARK: - Singleton
    static let shared = ImageDataManager()
    private init() {}
    
    
    // MARK: - Value
    // MARK: Private
    private lazy var imageCache = NSCache<NSString, UIImage>()
    private let queue = DispatchQueue(label: "ImageDataManagerQueue")

    
    private lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 90
        configuration.timeoutIntervalForRequest     = 90
        configuration.timeoutIntervalForResource    = 90
        return URLSession(configuration: configuration)
    }()
    
    
    // MARK: - Function
    // MARK: Public
    func download(url: URL?) -> AnyPublisher<UIImage, Error> {
        guard let url = url else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            return Just(cachedImage)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return downloadSession.dataTaskPublisher(for: url)
            .tryMap {
                guard let image = UIImage(data: $0.0) else { throw URLError(.badServerResponse) }
                return image
            }
            .handleEvents(receiveOutput: { self.imageCache.setObject($0, forKey: url.absoluteString as NSString) })
            .subscribe(on: queue)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

