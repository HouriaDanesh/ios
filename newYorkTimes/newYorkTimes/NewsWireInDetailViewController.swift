
import UIKit

class NewsWireInDetailViewController: UIViewController {
    @IBOutlet weak var section: UILabel!
    @IBOutlet weak var headline: UILabel!
    @IBOutlet weak var readMoreDetails: UIButton!
    @IBOutlet weak var paragraph: UILabel!
    @IBOutlet weak var relatedUrlContainer: UIStackView!
    
    var newswire: Article!
    
    
    func openLink(sender: UIButton!) -> Void {
        performSegueWithIdentifier("openLinkFromNewswireDetails", sender: sender)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = newswire.headline
        section.text = newswire.section
        headline.text = newswire.headline
        paragraph.text = newswire.leadParagraph
               readMoreDetails.addTarget(self, action: "openLink:", forControlEvents: UIControlEvents.TouchUpInside)
     
        var y: CGFloat =  0
        let width:CGFloat = relatedUrlContainer.frame.width - 200
        
       
        if newswire.relatedURL.count > 0 {
            
            for relatedLink in newswire.relatedURL{
                
                let button = UIButton(type: UIButtonType.Custom) as UIButton
                button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                
                button.frame = CGRectMake(0, y, width, 20)
                button.setTitle(relatedLink.url_text, forState: UIControlState.Normal)
                
                
                button.addTarget(self, action: "openLink:", forControlEvents: UIControlEvents.TouchUpInside)
                self.relatedUrlContainer.addSubview(button)
                y = y + 30
        }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
       override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "openLinkFromNewswireDetails"
        {
            let webView = segue.destinationViewController as! WebViewViewController
            if newswire.relatedURL.count > 0 {
                for relatedArticle in newswire.relatedURL{
                    let button = sender as! UIButton
                    if button.titleLabel!.text! == relatedArticle.url_text{
                        webView.url = relatedArticle.url
                        
                    }else if button.titleLabel!.text! == "Read Full Article Here"{
                        webView.url = newswire.webURL
                    }
                }
            }else {
                webView.url = newswire.webURL
            }
            
        }
    }
    
    
}
