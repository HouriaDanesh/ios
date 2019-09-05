
import UIKit

class NewswireTableViewCell: UITableViewCell {

    @IBOutlet weak var headline: UILabel!
    
    @IBOutlet weak var thumbnailPic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
           }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

           }

}
