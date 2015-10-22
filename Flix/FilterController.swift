
import UIKit

class FilterController: UIViewController
{
  @IBOutlet weak var tableView: UITableView!
  
  let cellIdentifier = "cellIdentifier"
  
  let future = Future<MovieListModifier>()
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    title = "Order & Filter"
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .Done,
      target: self,
      action: Selector("didTapDone")
    )
  }
  
  func didTapDone()
  {
    let modifier = MovieListModifier(
      filter: { _ in true },
      comparator: { _ in .Same }
    )
    future.completeWith(modifier)
  }
}

extension FilterController: UITableViewDataSource
{
  func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return 4
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    switch section {
    case 0:
      return 1
    case 1:
      return 2
    case 2:
      return 2
    case 3:
      return 2
    default:
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier).getOrElse(UITableViewCell(style: .Value1, reuseIdentifier: cellIdentifier))
    cell.accessoryType = .DisclosureIndicator
    
    switch indexPath {
    case let i where i.section == 0 && i.row == 0:
      cell.textLabel?.text = "Order by"
    case let i where i.section == 1 && i.row == 0:
      cell.textLabel?.text = "Max duration"
    case let i where i.section == 1 && i.row == 1:
      cell.textLabel?.text = "Min year"
    case let i where i.section == 2 && i.row == 0:
      cell.textLabel?.text = "Genres"
    case let i where i.section == 2 && i.row == 1:
      cell.textLabel?.text = "Rated"
    case let i where i.section == 3 && i.row == 0:
      cell.textLabel?.text = "Directors"
    case let i where i.section == 3 && i.row == 1:
      cell.textLabel?.text = "Writers"
    default:
      cell.textLabel?.text = nil
    }
    
    return cell
  }
}

extension FilterController: UITableViewDelegate
{
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}


