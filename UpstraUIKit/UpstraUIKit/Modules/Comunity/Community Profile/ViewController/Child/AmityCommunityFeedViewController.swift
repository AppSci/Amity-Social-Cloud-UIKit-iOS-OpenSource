//
//  AmityCommunityDetailBottomViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 14/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

enum CommunityFeedTab: String {
    case timeline
    case gallery
}

final public class AmityCommunityFeedViewController: AmityProfileBottomViewController {
    
    // MARK: - Properties
    private var timelineVC: AmityFeedViewController?
    private var galleryVC: AmityPostGalleryViewController?
    
    private var communityId: String = ""
    private var category: String = ""
    private var source: String = ""
    private var tab: CommunityFeedTab = .timeline
    private var isTimelineTracked = false
    private var isGalleryTracked = false
    
    var dataDidUpdateHandler: (() -> Void)?
    
    // MARK: - View lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupFeed()
        setupEmptyState()
    }
    
    func handleRefreshFeed()  {
        timelineVC?.handleRefreshing()
    }
    
    public static func make(communityId: String, category: String, source: String) -> AmityCommunityFeedViewController {
        let vc = AmityCommunityFeedViewController()
        vc.communityId = communityId
        vc.category = category
        vc.source = source
        // Timeline
        vc.timelineVC = AmityFeedViewController.make(feedType: .communityFeed(communityId: communityId))
        vc.timelineVC?.pageTitle = AmityLocalizedStringSet.timelineTitle.localizedString
        vc.timelineVC?.pageIndex = 0
        // Gallery
        vc.galleryVC = AmityPostGalleryViewController.make(
            targetType: .community,
            targetId: communityId
        )
        return vc
    }

    override func viewControllers(for pagerTabStripController: AmityPagerTabViewController) -> [UIViewController] {
        
        var viewControllers: [UIViewController] = []
        // 0. Timeline
        if let timelineVC = timelineVC {
            viewControllers.append(timelineVC)
        }
        // 1. Media Gallery
        if let galleryVC = galleryVC {
            viewControllers.append(galleryVC)
        }
        return viewControllers
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.tab == .timeline && !self.isTimelineTracked {
            self.isTimelineTracked = true
            AmityEventHandler.shared.trackCommunityViewGroup(id: self.communityId, tab: self.tab.rawValue, category: self.category, source: self.source)
        }
        
        if self.tab == .gallery && !self.isTimelineTracked {
            self.isTimelineTracked = true
            AmityEventHandler.shared.trackCommunityViewGroup(id: self.communityId, tab: self.tab.rawValue, category: self.category, source: self.source)
        }
        
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isTimelineTracked = false
        self.isGalleryTracked = false
    }
    
    private func setupFeed() {
        timelineVC?.dataDidUpdateHandler = { [weak self] _ in
            self?.dataDidUpdateHandler?()
        }
    }
    
    private func setupEmptyState() {
        timelineVC?.emptyViewHandler = { emptyView in
            let emptyView = emptyView as? AmityEmptyStateHeaderFooterView
            emptyView?.setLayout(layout: .label(title: AmityLocalizedStringSet.emptyTitleNoPosts.localizedString, subtitle: nil, image: AmityIconSet.emptyNoPosts), centerYOffset: -36)
        }
    }
    
    override func updateIndicator(for viewController: AmityPagerTabViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        
        guard indexWasChanged == true else { return }
      
        if toIndex == 0 {
            self.tab = .timeline
            if !self.isTimelineTracked {
                self.isTimelineTracked = true
                AmityEventHandler.shared.trackCommunityViewGroup(id: self.communityId, tab: self.tab.rawValue, category: self.category, source: self.source)
            }
        } else if toIndex == 1 {
            self.tab = .gallery
            if !self.isGalleryTracked {
                self.isGalleryTracked = true
                AmityEventHandler.shared.trackCommunityViewGroup(id: self.communityId, tab: self.tab.rawValue, category: self.category, source: self.source)
            }
        }

        //IMPORTANT!!!: call the following to let the master scroll controller know which view to control in the bottom section
        self.pageDelegate?.pageViewController(self.currentViewController, didSelectPageAt: toIndex)
    }
}
