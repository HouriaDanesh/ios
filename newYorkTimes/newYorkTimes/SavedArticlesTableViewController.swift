
import UIKit

class SavedArticlesTableViewController: UITableViewController {
    let indicator = UIActivityIndicatorView (activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var pathToFile = String()
    
    var savedArticles = [ArticleShort]()
    
    override func viewWillAppear(animated: Bool) {
        reloadData()
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        
        
    }
   
    func reloadData(){
        self.tableView.contentInset = UIEdgeInsetsMake(65, 0.0, 0.0, 0.0)
        indicator.color = UIColor .blackColor()
        indicator.frame = CGRectMake(0.0, 0.0, 50.0, 50.0)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        indicator.startAnimating()
        
        var filePath : String {
            let manager = NSFileManager.defaultManager()
            let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! 
            return url.URLByAppendingPathComponent("objectsArray").path!
        }
        
        self.pathToFile = filePath
        let emptyList = [ArticleShort]()
        let listOfarticles = NSKeyedUnarchiver.unarchiveObjectWithFile(self.pathToFile) as? [ArticleShort]
        if listOfarticles == nil {
            
            NSKeyedArchiver.archiveRootObject(emptyList, toFile: pathToFile)
        }else{
            self.savedArticles = listOfarticles!
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
              return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedArticles.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIndetifier  = "SavedArticleCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIndetifier, forIndexPath: indexPath) as! SavedArticlesTableViewCell
        
        let article = self.savedArticles[indexPath.row]
        cell.headline.text = article.headline
        cell.fullArticleBtn.titleLabel!.text = article.url
        cell.fullArticleBtn.setTitle(article.url, forState: .Normal)
        
        indicator.stopAnimating()
        return cell
    }
    
       override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "openSavedArticle" {
            
            let webView = segue.destinationViewController as! WebViewViewController
            let button = sender as! UIButton
                webView.url = button.titleLabel!.text
            
        }
        
    }
    
    
}
