//
//  AmityUIKit.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 2/6/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit
import AmitySDK

/// AmityUIKit
public final class AmityUIKitManager {
    
    private init() { }
    
    /// Setup AmityUIKit instance. Internally it creates AmityClient instance
    /// from AmitySDK.
    ///
    /// If you are using `AmitySDK` & `AmityUIKit` within same project, you can setup `AmityClient` instance using this method and access it using static property `client`.
    ///
    /// ~~~
    /// AmityUIKitManager.setup(...)
    /// ...
    /// let client: AmityClient = AmityUIKitManager.client
    /// ~~~
    ///
    /// - Parameters:
    ///   - apiKey: ApiKey provided by Amity
    ///   - region: The region to which this UIKit connects to. By default, region is .global
    public static func setup(apiKey: String,
                             region: AmityRegion = .global,
                             cameraPermissionDeniedText: String,
                             imagesPermissionDeniedText: String,
                             settingsString: String,
                             cancelString: String,
                             loadingTitle: String,
                             startTrackingFeedLoading: @escaping (()->()),
                             stopTrackingFeedLoading: @escaping (()->()),
                             startLoading: @escaping (()->()),
                             stopLoading: @escaping (()->())) {
        AmityUIKitManagerInternal.shared.setup(apiKey,
                                               region: region,
                                               cameraPermissionDeniedText: cameraPermissionDeniedText,
                                               imagesPermissionDeniedText: imagesPermissionDeniedText,
                                               settingsString: settingsString,
                                               cancelString: cancelString,
                                               loadingTitle: loadingTitle,
                                               startTrackingFeedLoading: startTrackingFeedLoading,
                                               stopTrackingFeedLoading: stopTrackingFeedLoading,
                                               startLoading: startLoading,
                                               stopLoading: stopLoading)
    }
    
    /// Setup AmityUIKit instance. Internally it creates AmityClient instance from AmitySDK.
    ///
    /// If you do not need extra configuration, please use setup(apiKey:_, region:_) method instead.
    ///
    /// Also if you are using `AmitySDK` & `AmityUIKit` within same project, you can setup `AmityClient` instance using this method and access it using static property `client`.
    ///
    /// ~~~
    /// AmityUIKitManager.setup(...)
    /// ...
    /// let client: AmityClient = AmityUIKitManager.client
    /// ~~~
    ///
    /// - Parameters:
    ///   - apiKey: ApiKey provided by Amity
    ///   - endpoint: Custom Endpoint to which this UIKit connects to.
    public static func setup(apiKey: String, endpoint: AmityEndpoint) {
        AmityUIKitManagerInternal.shared.setup(apiKey, endpoint: endpoint)
    }
    
    // MARK: - Setup Authentication
    
    public static func setup(isExploreAllowed: Bool) {
        AmityUIKitManagerInternal.shared.setup(isExploreAllowed: isExploreAllowed)
    }
    
    /// Registers current user with server. This is analogous to "login" process. If the user is already registered, local
    /// information is used. It is okay to call this method multiple times.
    ///
    /// Note:
    /// You do not need to call `unregisterDevice` before calling this method. If new user is being registered, then sdk handles unregistering process automatically.
    /// So simply call `registerDevice` with new user information.
    ///
    /// - Parameters:
    ///   - userId: Id of the user
    ///   - displayName: Display name of the user. If display name is not provided, user id would be set as display name.
    ///   - authToken: Auth token for this user if you are using secure mode.
    ///   - completion: Completion handler.
    public static func registerDevice(
        withUserId userId: String,
        displayName: String?,
        authToken: String? = nil,
        completion: AmityRequestCompletion? = nil) {
        AmityUIKitManagerInternal.shared.registerDevice(userId, displayName: displayName, authToken: authToken, completion: completion)
    }
    
    /// Unregisters current user. This removes all data related to current user & terminates conenction with server. This is analogous to "logout" process.
    /// Once this method is called, the only way to re-establish connection would be to call `registerDevice` method again.
    ///
    /// Note:
    /// You do not need to call this method before calling `registerDevice`.
    public static func unregisterDevice() {
        AmityUIKitManagerInternal.shared.unregisterDevice()
    }
    
    /// Registers this device for receiving apple push notification
    /// - Parameter deviceToken: Correct apple push notificatoin token received from the app.
    public static func registerDeviceForPushNotification(_ deviceToken: String, completion: AmityRequestCompletion? = nil) {
        AmityUIKitManagerInternal.shared.registerDeviceForPushNotification(deviceToken, completion: completion)
    }
    
    /// Unregisters this device for receiving push notification related to AmitySDK.
    public static func unregisterDevicePushNotification() {
        AmityUIKitManagerInternal.shared.unregisterDevicePushNotification()
    }
    
    public static func setEnvironment(_ env: [String: Any]) {
        AmityUIKitManagerInternal.shared.env = env
    }
    
    // MARK: - Variable
    
    /// Public instance of `AmityClient` from `AmitySDK`. If you are using both`AmitySDK` & `AmityUIKit` in a same project, we recommend to have only one instance of `AmityClient`. You can use this instance instead.
    public static var client: AmityClient {
        return AmityUIKitManagerInternal.shared.client
    }
    
    public static var feedUISettings: AmityFeedUISettings {
        return AmityFeedUISettings.shared
    }
    
    static var bundle: Bundle {
        return Bundle(for: self)
    }
    
    // MARK: - Helper methods
    
    public static func set(theme: AmityTheme) {
        AmityThemeManager.set(theme: theme)
    }
    
    public static func set(typography: AmityTypography) {
        AmityFontSet.set(typography: typography)
    }
    
    public static func set(eventHandler: AmityEventHandler) {
        AmityEventHandler.shared = eventHandler
    }
    
    public static func set(channelEventHandler: AmityChannelEventHandler) {
        AmityChannelEventHandler.shared = channelEventHandler
    }
}

final class AmityUIKitManagerInternal: NSObject {
    
    // MARK: - Properties
    
    public static let shared = AmityUIKitManagerInternal()
    private var _client: AmityClient?
    private var apiKey: String = ""
    
    private(set) var cameraPermissionDeniedText = ""
    private(set) var imagesPermissionDeniedText = ""
    private(set) var settingsString = ""
    private(set) var cancelString = ""
    private(set) var loadingTitle = ""
    private(set) var isExploreAllowed = false
    
    private(set) var fileService = AmityFileService()
    private(set) var messageMediaService = AmityMessageMediaService()
    
    var currentUserId: String { return client.currentUserId ?? "" }
    
    var client: AmityClient {
        guard let client = _client else {
            fatalError("Something went wrong. Please ensure `AmityUIKitManager.setup(:_)` get called before accessing client.")
        }
        return client
    }
    
    var env: [String: Any] = [:]
    
    var startTrackingFeedLoading: (()->())?
    var stopTrackingFeedLoading: (()->())?
    
    var startLoading: (() -> Void)?
    var stopLoading: (() -> Void)?
    
    // MARK: - Initializer
    
    private override init() { }
    
    // MARK: - Setup functions
    
    func setup(_ apiKey: String,
               region: AmityRegion,
               cameraPermissionDeniedText: String,
               imagesPermissionDeniedText: String,
               settingsString: String,
               cancelString: String,
               loadingTitle: String,
               startTrackingFeedLoading: @escaping (()->()),
               stopTrackingFeedLoading: @escaping (()->()),
               startLoading: @escaping (()->()),
               stopLoading: @escaping (()->())) {
        guard let client = try? AmityClient(apiKey: apiKey, region: region) else { return }
        
        self.cameraPermissionDeniedText = cameraPermissionDeniedText
        self.imagesPermissionDeniedText = imagesPermissionDeniedText
        self.settingsString = settingsString
        self.cancelString = cancelString
        self.loadingTitle = loadingTitle
        self.startTrackingFeedLoading = startTrackingFeedLoading
        self.stopTrackingFeedLoading = stopTrackingFeedLoading
        self.startLoading = startLoading
        self.stopLoading = stopLoading
        _client = client
        _client?.clientErrorDelegate = self
    }
    
    func setup(_ apiKey: String, endpoint: AmityEndpoint) {
        guard let client = try? AmityClient(apiKey: apiKey, endpoint: endpoint) else { return }
        
        _client = client
        _client?.clientErrorDelegate = self
    }
    
    func setup(_ apiKey: String, httpUrl: String = "", socketUrl: String = "") {
        guard let client = try? AmityClient(apiKey: apiKey, httpUrl: httpUrl, socketUrl: socketUrl) else { return }
        
        _client = client
        _client?.clientErrorDelegate = self
    }
    
    func setup(isExploreAllowed: Bool) {
        self.isExploreAllowed = isExploreAllowed
    }

    func registerDevice(_ userId: String,
                        displayName: String?,
                        authToken: String?,
                        completion: AmityRequestCompletion?) {
        
        client.login(userId: userId, displayName: displayName, authToken: authToken, completion: completion)
        didUpdateClient()
    }
    
    func unregisterDevice() {
        AmityFileCache.shared.clearCache()
        self._client?.logout()
    }
    
    func didUpdateClient() {
        // Update file repository to use in file service.
        fileService.fileRepository = AmityFileRepository(client: client)
        messageMediaService.fileRepository = AmityFileRepository(client: client)
    }
    
    func registerDeviceForPushNotification(_ deviceToken: String, completion: AmityRequestCompletion? = nil) {
        self._client?.registerDeviceForPushNotification(withDeviceToken: deviceToken, completion: completion)
    }
    
    func unregisterDevicePushNotification(completion: AmityRequestCompletion? = nil) {
        guard let currentUserId = self._client?.currentUserId else { return }
        client.unregisterDeviceForPushNotification(forUserId: currentUserId, completion: completion)
    }
    
}

extension AmityUIKitManagerInternal: AmityClientErrorDelegate {
    
    func didReceiveAsyncError(_ error: Error) {
        AmityHUD.show(.error(message: error.localizedDescription))
    }
}
