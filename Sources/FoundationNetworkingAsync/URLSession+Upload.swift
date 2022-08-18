//
//  URLSession+Upload.swift
//  
//
//  Created by Christopher Baltzer on 2022-08-18.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


#if os(Linux)

public extension URLSession {
    
    /**
     Uploads data to a URL and delivers the result asynchronously.
     - Note: FoundationNetworkingAsync
     */
    func upload(for request: URLRequest, fromFile fileURL: URL) async throws -> (Data, URLResponse) {
        let fileData = try Data(contentsOf: fileURL)
        return try await upload(for: request,
                                from: fileData,
                                delegate: nil)
    }
    
    
    /**
     Uploads data to a URL and delivers the result asynchronously.
     - Note: FoundationNetworkingAsync
     */
    func upload(for request: URLRequest, fromFile fileURL: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        let fileData = try Data(contentsOf: fileURL)
        return try await upload(for: request,
                                from: fileData,
                                delegate: delegate)
    }
    
    
    /**
     Uploads data to a URL based on the specified URL request and delivers the result asynchronously.
     - Note: FoundationNetworkingAsync
     */
    func upload(for request: URLRequest, from bodyData: Data) async throws -> (Data, URLResponse) {
        return try await upload(for: request,
                                from: bodyData,
                                delegate: nil)
    }
    
    
    /**
     Uploads data to a URL based on the specified URL request and delivers the result asynchronously.
     - Note: FoundationNetworkingAsync
     */
    func upload(for request: URLRequest, from bodyData: Data, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        return try await Task { () -> (Data, URLResponse) in
            let blocking = BlockingNetworking()
            return try blocking.blockingUpload(session: self,
                                               request: request,
                                               from: bodyData,
                                               delegate: delegate)
        }.result.get()
    }
    
}

#endif
