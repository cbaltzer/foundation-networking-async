//
//  URLSession+Async.swift
//  
//
//  Created by Christopher Baltzer on 2022-08-17.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


#if os(Linux)

struct BlockingNetworking {
    
    func blockingData(session: URLSession, request: URLRequest, delegate: URLSessionTaskDelegate?) throws -> (Data, URLResponse) {
    
        var data = Data()
        var response = URLResponse()
        var error: Error? = nil
        
        let semaphore = DispatchSemaphore(value: 0)
    
        let completion: (Data?, URLResponse?, Error?) -> () = { resData, res, err in
            if let d = resData {
                data = d
            }
            
            if let r = res {
                response = r
            }
            
            error = err
            semaphore.signal()
        }
        
        let task = session.dataTask(with: request, completionHandler: completion)
        if #available(macOS 12.0, *) {
            task.delegate = delegate
        }
        task.resume()
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
        if let throwable = error {
            throw throwable
        }
        
        return (data, response)
    }

    
    func blockingDownload(session: URLSession, request: URLRequest, resumeData: Data?, delegate: URLSessionTaskDelegate?) throws -> (URL, URLResponse) {
    
        var url = URL(fileURLWithPath: NSTemporaryDirectory())
        var response = URLResponse()
        var error: Error? = nil
        
        let semaphore = DispatchSemaphore(value: 0)
    
        let completion: (URL?, URLResponse?, Error?) -> () = { resURL, res, err in
            if let u = resURL {
                url = u
            }
            
            if let r = res {
                response = r
            }
            
            error = err
            semaphore.signal()
        }
        
        
        var task: URLSessionTask
        if let resumeData = resumeData {
            task = session.downloadTask(withResumeData: resumeData, completionHandler: completion)
        } else {
            task = session.downloadTask(with: request, completionHandler: completion)
        }
        if #available(macOS 12.0, *) {
            task.delegate = delegate
        }
        task.resume()
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
        if let throwable = error {
            throw throwable
        }
        
        return (url, response)
    }

    
    func blockingUpload(session: URLSession, request: URLRequest, from uploadData: Data?, delegate: URLSessionTaskDelegate?) throws -> (Data, URLResponse) {
    
        var data = Data()
        var response = URLResponse()
        var error: Error? = nil
        
        let semaphore = DispatchSemaphore(value: 0)
    
        let completion: (Data?, URLResponse?, Error?) -> () = { resData, res, err in
            if let d = resData {
                data = d
            }
            
            if let r = res {
                response = r
            }
            
            error = err
            semaphore.signal()
        }
        
        let task = session.uploadTask(with: request, from: uploadData, completionHandler: completion)
        if #available(macOS 12.0, *) {
            task.delegate = delegate
        }
        task.resume()
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
        if let throwable = error {
            throw throwable
        }
        
        return (data, response)
    }
    
}

#endif

