//
//  AboutUsWebviewController.swift
//  PlanItOptions
//
//  Created by Yale on 16/7/4.
//  Copyright © 2016年 Yale. All rights reserved.
//

import UIKit

class AboutUsWebviewController: UIViewController, UIWebViewDelegate {
    
    //关于我们的webview
    @IBOutlet var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let backButtom = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: "dismiss")
        self.navigationItem.leftBarButtonItem = backButtom
        
        webView.delegate = self
        
        //设置初始加载网页
        let url = NSURL(string: "https://zoomyale.gitbooks.io/1/content/")
        let request = NSURLRequest(URL: url!)
        
        webView.loadRequest(request)

    }

    //开始加载网页
    func webViewDidStartLoad(webView: UIWebView) {
        print("start")
        var indicator = WIndicator.showIndicatorAddedTo(self.navigationController!.view, animation: true)
        
    }
    
    //完成加载网页
    func webViewDidFinishLoad(webView: UIWebView) {
        print("finish")
        WIndicator.removeIndicatorFrom(self.navigationController!.view, animation: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismiss(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}