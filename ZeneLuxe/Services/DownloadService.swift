//
//  DownloadService.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 14/02/24.
//

import Foundation


class DownloadService: NSObject {
    //MARK: Properties
    lazy var downloadSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "com.bgDownloadSession")
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    private var currentlyDownloadingTask: URLSessionDownloadTask?
    private var resumeData: Data?
    var didFinishDownload: ((_ location: URL)->())?
    private var downloadingForUrl: URL?
    
    //MARK: Start Download
    func startDownload(urlStr: String) {
        ///Stop any running download
        self.stopTask()
        if let url = URL(string: urlStr) {
            self.downloadingForUrl = url
            ///Checking audio is already downloaded or not
            let historyResult = isAudioExistWithLoc()
            if historyResult.isExist {
                if let destinationUrl = historyResult.location {
                    self.didFinishDownload?(destinationUrl)
                    return
                }
            }
            ///Downloading audio
            printLog("Downloading: \(urlStr)")
            let request = URLRequest(url: url)
            self.currentlyDownloadingTask = downloadSession.downloadTask(with: request)
            self.currentlyDownloadingTask?.resume()
        } else {
            printLog("AudioService: Invalid URL: \(urlStr)")
        }
    }
    ///
    ///Checking weather the audio is already downloaded
    ///
    private func isAudioExistWithLoc() -> (isExist: Bool, location: URL?) {
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return (false, nil) }
        if let fileName = self.downloadingForUrl?.lastPathComponent {
            let filePath = documentsPath.appendingPathComponent(fileName, isDirectory: false)
            if #available(iOS 16.0, *) {
                if self.isFileExist(destinationPath: filePath.path()) {
                    printLog("Audio Already exist.")
                    return (true, filePath)
                }
            } else {
                if self.isFileExist(destinationPath: filePath.relativePath) {
                    printLog("Audio Already exist.")
                    return (true, filePath)
                }
            }
            
        }
        return (false, nil)
    }
    ///
    ///Cancel downloading task
    ///
    func stopTask() {
        if currentlyDownloadingTask != nil {
            currentlyDownloadingTask?.cancel()
            currentlyDownloadingTask = nil
            resumeData = nil
            printLog("Cancelled previously running task.")
        }
    }
    //MARK: Pause Download
    func pauseTask() {
        currentlyDownloadingTask?.cancel(byProducingResumeData: { data in
            printLog("resumeData: \(data?.base64EncodedString())")
            self.resumeData = data
        })
    }
    //MARK: Resume Task
    func resumeTask() {
        if let resumeData = resumeData {
            printLog("Resume download")
            self.currentlyDownloadingTask = downloadSession.downloadTask(withResumeData: resumeData)
            self.currentlyDownloadingTask?.resume()
        } else {
            self.startDownload(urlStr: downloadingForUrl?.absoluteString ?? "")
        }
    }
}

extension DownloadService: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        printLog("Download complete: \(location)")
        if let destinationUrl = localFilePath(for: location) {
            do {
                if #available(iOS 16.0, *) {
                    if isFileExist(destinationPath: destinationUrl.path()) {
                        printLog("Already saved!")
                    } else {
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        printLog("Saved to: \(destinationUrl)")
                    }
                } else {
                    if isFileExist(destinationPath: destinationUrl.relativePath) {
                        printLog("Already saved!")
                    } else {
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        printLog("Saved to: \(destinationUrl)")
                    }
                }
                self.didFinishDownload?(destinationUrl)
            } catch {
                printLog("Unable to move downloaded file to \(destinationUrl)")
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        printLog("Total: \(totalBytesExpectedToWrite)Bytes, Downloaded: \(totalBytesWritten)Bytes")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        printLog("Resume at: \(fileOffset)Bytes, Total: \(expectedTotalBytes)Bytes")
    }
    
    func localFilePath(for url: URL) -> URL? {
        var url = url
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        var fileName = ""
        if let name = self.downloadingForUrl?.lastPathComponent {
            fileName = name
        } else {
            url.deletePathExtension()
            url.appendPathExtension("mp3")
            fileName = url.lastPathComponent
        }
        printLog("File name: \(fileName)")
        return documentsPath.appendingPathComponent(fileName, isDirectory: false)
    }
    
    func isFileExist(destinationPath: String) -> Bool {
        return FileManager.default.fileExists(atPath: destinationPath)
    }
}
