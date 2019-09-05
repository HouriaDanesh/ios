
import UIKit

class WebViewViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var browser: UIWebView!
    
    
    var url: String!
    let indicator:UIActivityIndicatorView = UIActivityIndicatorView  (activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.color = UIColor .blackColor()
        indicator.frame = CGRectMake(0.0, 0.0, 50.0, 50.0)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        indicator.startAnimating()
        loadTheWebPage()
            }
    
    func loadTheWebPage(){
        
        let urlString = self.url
        let myURLRequest = NSURLRequest(URL: NSURL(string: "\(urlString!)")!)
        browser.loadRequest(myURLRequest)
        indicator.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
          }
    

    
}
