
import UIKit

class SearchedArticleInDetailsViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var headline: UILabel!
    @IBOutlet weak var paragraph: UILabel!
    @IBOutlet weak var imageContainer: UIImageView!
    @IBOutlet weak var linkButton: UIButton!
    
    var article: Article!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = article!.headline
        headline.text = article.headline
        paragraph.text = article.leadParagraph
        linkButton.setTitle(article.webURL, forState: .Normal)
       
        if(article.media.count > 0){
            let thumbnailUrl: String = "http://nytimes.com/"  + article.media[0]
            print(thumbnailUrl)
            if let url = NSURL(string: thumbnailUrl) {
                if let data = NSData(contentsOfURL: url) {
                    imageContainer.image = UIImage(data: data)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           }
    
      override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "OpenLink"
        {
            let webView = segue.destinationViewController as! WebViewViewController
            webView.url = article.webURL
        }
    }
    
    @IBAction func openLink(sender: UIButton) {
        
    }
    
}
