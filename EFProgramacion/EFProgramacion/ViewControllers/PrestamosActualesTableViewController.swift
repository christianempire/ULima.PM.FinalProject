import UIKit


class HeadlineTableViewCell: UITableViewCell {
    @IBOutlet weak var book_title: UILabel!
    @IBOutlet weak var book_author: UILabel!
    @IBOutlet weak var book_pic: UIImageView!
    @IBOutlet weak var book_renovate: UIButton!
    @IBOutlet weak var book_transfer: UIButton!
}

class PrestamosActualesTableViewController: UITableViewController {
    
    
    let access : Firebase_Access = Firebase_Access()
    var book_list : [Book] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let userName = UserDefaults.standard.object(forKey: "USERNAME") as? String
        //access.get_user_books(username: userName!, completition: <#T##([Book]) -> Void#>)
        
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return book_list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HeadlineTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "PrestamoCell", for: indexPath) as! HeadlineTableViewCell
        

        cell.book_author.text = book_list[indexPath.row].author
        cell.book_title.text = book_list[indexPath.row].title
        cell.book_pic.downloadedFrom(link: book_list[indexPath.row].image)

        return cell
    }

    override func viewDidAppear(_ animated: Bool) {
        let access = Firebase_Access()
        book_list = access.get_user_books()
        self.tableView.reloadData()
    }


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
