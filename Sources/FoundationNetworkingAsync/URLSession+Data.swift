//
//  URLSession+Data.swift
//  
//
//  Created by Christopher Baltzer on 2022-08-17.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


#if os(Linux)

public extension URLSession {
    
    /**
    Downloads the contents of a URL and delivers the data asynchronously.
    - Note: FoundationNetworkingAsync
     */
    func data(from url: URL) async throws -> (Data, URLResponse) {
        let request = URLRequest(url: url)
        return try await data(for: request,
                              delegate: nil)
    }

    
    /**
    Downloads the contents of a URL and delivers the data asynchronously.
    - Note: FoundationNetworkingAsync
     */
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        let request = URLRequest(url: url)
        return try await data(for: request,
                              delegate: delegate)
    }
    
    
    /**
    Downloads the contents of a URL based on the specified URL request and delivers the data asynchronously.
    - Note: FoundationNetworkingAsync
     */
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await data(for: request,
                              delegate: nil)
    }
    
    /**
    Downloads the contents of a URL based on the specified URL request and delivers the data asynchronously.
    - Note: FoundationNetworkingAsync
     */
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        return try await Task { () -> (Data, URLResponse) in
            let blocking = BlockingNetworking()
            return try blocking.blockingData(session: self,
                                             request: request,
                                             delegate: delegate)
        }.result.get()
    }
    
}

#endif
