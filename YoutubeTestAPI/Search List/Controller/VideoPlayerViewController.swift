//
//  VideoViewController.swift
//  YoutubeTestAPI
//
//  Created by Sergio Veliz on 11/9/18.
//  Copyright © 2018 Sergio Veliz. All rights reserved.
//

import UIKit
import WebKit

class VideoPlayerViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var dislikesCountLabel: UILabel!
    @IBOutlet weak var publishedLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var videoId = ""
    var videoResponse: VideoResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create url for request
        let myURL = "https://www.youtube.com/embed/" + videoId
        
        // player script
        var frameVideo = "<html><body>"
        let paddingTop = myURL.contains("youtube.com") || myURL.contains("youtu.be") ? "70%" : "100%";
        let content = "<div style=\"position:relative; width: 100%; padding-top: " + paddingTop + "\"><iframe style=\"position: absolute; width:100%; height:100%; top:0; left:0; right:0; bottom:0;\" src=\"" + myURL + "\" frameborder=\"0\" allowfullscreen></iframe></div>"
        frameVideo += content
        frameVideo += "</body></html>"
        
        webView.loadHTMLString(frameVideo, baseURL: nil)
        
        DispatchQueue.main.async {
            self.getVideo()
        }
    }
    
    func loadInterfaceData() {
        if videoResponse?.items.count != 0 {
        titleLabel.text = videoResponse?.items[0].snippetI.title
        
        viewsCountLabel.text = "\(String(describing: (videoResponse?.items[0].statistics.viewCount)!)) \nviews"
        likesCountLabel.text = "\(String(describing: (videoResponse?.items[0].statistics.likeCount)!)) \nlikes"
        dislikesCountLabel.text = "\(String(describing: (videoResponse?.items.first?.statistics.dislikeCount)!)) \ndislikes"
        publishedLabel.text = "Published: \(String(describing: (videoResponse?.items.first?.snippetI.getDate())!))"
        commentsCountLabel.text = "Comments: \(String(describing: (videoResponse?.items.first?.statistics.commentCount)!))"
        channelTitleLabel.text = videoResponse?.items.first?.snippetI.channelTitle
        descriptionTextView.text = videoResponse?.items.first?.snippetI.description
//        videoResponse?.items.first?.snippetI.tags.description
        }
    }
    
    // MARK: - Requests
    
    @objc func getVideo() {
        
        SearchAPI.getVideo(videoId: videoId) { (videoResponse) in
            self.videoResponse = videoResponse
            self.loadInterfaceData()
        }
    }

}

