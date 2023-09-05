//
//  APIManager.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 29.08.2023.
//

import Foundation
import AVFoundation
import SwiftyDropbox

class APIManager {
    
    // Shared Instance
    static let shared: APIManager = {
        return APIManager()
    }()
    
    private init() {}
    
    // MARK: - Properties -
                
    static private var appKey: String = "zs9x1sysz05g7kk"
                
    static private var limit: UInt32 = 25
    static private var currentCursor: String?
          
  
    // MARK: - Methods -
    
    // MARK: - Authentication Methods

    static func setup() {
        // Setup With App Key
        DropboxClientsManager.setupWithAppKey(appKey)
        
        // Get Saved Access Token
        let accessToken = CacheManager.shared.get(key: .accessToken, type: String.self)
        
        // Auth Token
        if let accessToken = accessToken {
            DropboxClientsManager.authorizedClient = DropboxClient(accessToken: accessToken)
            
            checkAccessToken { result in
                if result {
                    AppConfiguration.mainVC()
                } else {
                    AppConfiguration.authVC()
                }
            }
            
        } else {
            AppConfiguration.authVC()
        }
    }
    
    static func authorizeFromControllerV2(viewController: UIViewController) {
        let scopes: [String] = ["account_info.read", "files.metadata.read", "files.metadata.write", "files.content.read", "files.content.write"]
    
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: scopes, includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: viewController,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
            scopeRequest: scopeRequest
        )
    }
    
    static func checkAccessToken(completion: @escaping (Bool) -> Void) {
        DropboxClientsManager.authorizedClient?.users.getCurrentAccount().response { (account: Users.FullAccount?, error: CallError<Void>?) in
            if let account = account {

                let id = account.accountId
                let name = account.name.displayName
                let email = account.email
                let photoURL = account.profilePhotoUrl
                
                CacheManager.shared.set(key: .user, value: UserML(id: id, name: name, email: email, photoURL: photoURL))
                
                print("Access exists. Account: \(account)")
                completion(true)
            } else {
                print("The token has expired or you have unknow Error. You need to refresh/create the token.")
                completion(false)
            }
        }
    }
              
    
    // MARK: - Recieve Media Files Methods
    
    static func fetchMediaFilesForFirstTime(_ completion: @escaping (_ result: [MediaFile]) -> Void ) {
                    
        DropboxClientsManager.authorizedClient?.files.listFolder(path: "", limit: APIManager.limit).response { response, error in
            if let result = response {
                var mediaItems: [MediaFile] = []

                for entry in result.entries {
                    if let fileMetadata = entry as? Files.FileMetadata {
                        if let mediaType = AppConfiguration.getMediaType(from: fileMetadata.name) {
                            let mediaItem = MediaFile(id: fileMetadata.id,
                                                      name: fileMetadata.name,
                                                      size: fileMetadata.size,
                                                      path: fileMetadata.pathLower,
                                                      modified: fileMetadata.clientModified,
                                                      image: nil,
                                                      videoURL: nil,
                                                      mediaType: mediaType)
                                                        
                            mediaItems.append(mediaItem)
                        }
                    }
                }
                                                    
                // Save the new cursor for the next call
                self.currentCursor = result.cursor
                                            
                // Completion
                completion(mediaItems)
                                                
            } else if let err = error {
                completion([])
                print("Error fetching media files: \(err)")
            }
        }
    }
    
    
    static func fetchMoreMediaFiles(_ completion: @escaping (_ result: [MediaFile], _ canUsersDownloadMore: Bool) -> Void ) {
        guard let currentCursor = currentCursor else {
            completion([], true)
            print("• NIL")
            return
        }
        
        DropboxClientsManager.authorizedClient?.files.listFolderContinue(cursor: currentCursor).response { response, error in
            if let result = response {
                var mediaItems: [MediaFile] = []
                
                for entry in result.entries {
                    if let fileMetadata = entry as? Files.FileMetadata {
                        if let mediaType = AppConfiguration.getMediaType(from: fileMetadata.name) {
                            let mediaItem = MediaFile(id: fileMetadata.id,
                                                      name: fileMetadata.name,
                                                      size: fileMetadata.size,
                                                      path: fileMetadata.pathLower,
                                                      modified: fileMetadata.clientModified,
                                                      image: nil,
                                                      videoURL: nil,
                                                      mediaType: mediaType)
                                                       
                            
                            mediaItems.append(mediaItem)
                        }
                    }
                }
                
                // Save the new cursor for the next call
                self.currentCursor = result.cursor
                
                if result.entries.count == 0 {
                    completion([], true)
                } else {
                    completion(mediaItems, false)
                }
                            
            } else if let err = error {
                print("Error fetching more media files: \(err)")
            }
        }
    }


    
    // MARK: - Download Methods
    
    static func getVideoFile(withPath path: String, completion: @escaping (UIImage?, URL?) -> Void) {
        DropboxClientsManager.authorizedClient?.files.download(path: path).response { response, error in
            if let (_, data) = response, error == nil {
                // Get the path to the temporary file where the downloaded video is saved
                let temporaryFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(path)
                
                do {
                    // Save the downloaded video on a temporary path
                    try data.write(to: temporaryFileURL)
                    
                    // We get a video preview from a temporary file
                    if let thumbnailImage = AppConfiguration.generateThumbnail(forVideoAt: temporaryFileURL) {
                        completion(thumbnailImage, temporaryFileURL)
                    } else {
                        print("Error: Could not generate video thumbnail.")
                        completion(nil, temporaryFileURL)
                    }
                } catch {
                    print("Error saving video data: \(error)")
                    completion(nil, temporaryFileURL)
                }
            } else if let err = error {
                print("Error downloading video: \(err)")
                completion(nil, nil)
            }
        }
    }
    
    static func getImageFile(withPath path: String, completion: @escaping (UIImage?) -> Void) {
        DropboxClientsManager.authorizedClient?.files.download(path: path).response { response, error in
            if let (_, data) = response, error == nil {
                
                if let image = UIImage(data: data) {
                    // Successfully Donwloaded
                    completion(image)
                } else {
                    print("Error: Could not create image from data.")
                    completion(nil)
                }
            } else if let err = error {
                print("Error downloading image: \(err)")
                completion(nil)
            }
        }
    }
}
