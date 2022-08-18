//
//  URLSession+Download.swift
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
     Retrieves the contents of a URL and delivers the URL of the saved file asynchronously.
     - Note: FoundationNetworkingAsync
     */
    func download(from url: URL) async throws -> (URL, URLResponse) {
        let request = URLRequest(url: url)
        return try await download(for: request,
                                  delegate: nil)
    }

    
    /**
     Retrieves the contents of a URL and delivers the URL of the saved file asynchronously.
     - Note: FoundationNetworkingAsync
     */
    func download(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (URL, URLResponse) {
        let request = URLRequest(url: url)
        return try await download(for: request,
                                  delegate: delegate)
    }
    
    
    /**
     Retrieves the contents of a URL based on the specified URL request and delivers the URL of the saved file asynchronously.
     - Note: FoundationNetworkingAsync
     */
    func download(for request: URLRequest) async throws -> (URL, URLResponse) {
        return try await download(for: request,
                                  delegate: nil)
    }
    
    
    /**
     Retrieves the contents of a URL based on the specified URL request and delivers the URL of the saved file asynchronously.
     - Note: FoundationNetworkingAsync
     */
    func download(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (URL, URLResponse) {
        return try await Task { () -> (URL, URLResponse) in
            let blocking = BlockingNetworking()
            return try blocking.blockingDownload(session: self,
                                                 request: request,
                                                 resumeData: nil,
                                                 delegate: delegate)
        }.result.get()
    }
    
    
    /**
     Resumes a previously-paused download and delivers the URL of the saved file asynchronously.
     - Note: FoundationNetworkingAsync
     */
    func download(resumeFrom: Data) async throws -> (URL, URLResponse) {
        return try await download(resumeFrom: resumeFrom,
                                  delegate: nil)
    }
    
    
    /**
    Resumes a previously-paused download and delivers the URL of the saved file asynchronously.
    - Note: FoundationNetworkingAsync
     */
    func download(resumeFrom: Data, delegate: URLSessionTaskDelegate?) async throws -> (URL, URLResponse) {
        return try await Task { () -> (URL, URLResponse) in
            // fake request just to fill the param
            let req = URLRequest(url: URL(fileURLWithPath: NSTemporaryDirectory()))
            let blocking = BlockingNetworking()
            return try blocking.blockingDownload(session: self,
                                                 request: req,
                                                 resumeData: resumeFrom,
                                                 delegate: delegate)
        }.result.get()
    }
    
}

#endif
