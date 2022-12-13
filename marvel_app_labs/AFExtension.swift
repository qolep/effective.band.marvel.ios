import Foundation
import Alamofire

extension DataRequest {
    struct AnyPayload<T: Decodable>: Decodable {
        let data: T?
    }
    @discardableResult
    func responseDataDecodable<T: Decodable>(
        of type: T.Type = T.self,
        queue: DispatchQueue = .main,
        dataPreprocessor: DataPreprocessor = DecodableResponseSerializer<T>.defaultDataPreprocessor,
        decoder: DataDecoder = JSONDecoder(),
        emptyResponseCodes: Set<Int> = DecodableResponseSerializer<T>.defaultEmptyResponseCodes,
        emptyRequestMethods: Set<HTTPMethod> = DecodableResponseSerializer<T>.defaultEmptyRequestMethods,
        completionHandler: @escaping (AFDataResponse<AnyPayload<T>>) -> Void
    ) -> Self {
        response(queue: queue,
                 responseSerializer: DecodableResponseSerializer(dataPreprocessor: dataPreprocessor,
                                                                 decoder: decoder,
                                                                 emptyResponseCodes: emptyResponseCodes,
                                                                 emptyRequestMethods: emptyRequestMethods),
                 completionHandler: completionHandler)
    }
}
