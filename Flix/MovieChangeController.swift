
import UIKit

class MovieChangeController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  let future = Future<MovieListChangeReference?>()

  fileprivate let cellIdentifier = "cellIdentifier"

  fileprivate var selectedIdentifiers = [MovieListChangeIdentifier]() {
    
    willSet(newSelectedIdentifiers) {
      navigationController?.setToolbarHidden(newSelectedIdentifiers.count < 2, animated: true)
    }

    didSet {
      let removedIdentifiers = oldValue
        .filter { selectedIdentifiers.contains($0) == false}
      
      let addedIdentifiers = selectedIdentifiers
        .filter { oldValue.contains($0) == false }
      
      var modifiedIdentifiers = [MovieListChangeIdentifier]()
      modifiedIdentifiers.append(contentsOf: removedIdentifiers)
      modifiedIdentifiers.append(contentsOf: addedIdentifiers)
      
      let indexPaths = modifiedIdentifiers
        .flatMap { identifier in group.references.index { $0.identifier == identifier }  }
        .flatMap { Int($0) }
        .map { IndexPath(row: $0, section: 0) }
      
      tableView.reloadRows(at: indexPaths, with: .automatic)
    }
  }
  
  fileprivate let group: MovieListChangeGroup
  required init(group: MovieListChangeGroup) {
    self.group = group
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = group.title
    
    if group.multipleSelection {
      navigationItem.rightBarButtonItem = UIBarButtonItem(
        barButtonSystemItem: .done,
        target: self,
        action: #selector(MovieChangeController.didTapDoneButton)
      )
      
      toolbarItems = [
        UIBarButtonItem(
          barButtonSystemItem: .flexibleSpace,
          target: nil,
          action: nil
        ),
        UIBarButtonItem(
          title: "Clear",
          style: .plain,
          target: self,
          action: #selector(MovieChangeController.didTapClearButton)
        ),
        UIBarButtonItem(
          barButtonSystemItem: .flexibleSpace,
          target: nil,
          action: nil
        )
      ]
    }
    
    tableView.reloadData()
  }
    
  func didTapDoneButton() {
    let validReferences = group.references
      .filter { selectedIdentifiers.contains($0.identifier) }

    let combinedIdentifier = selectedIdentifiers
      .reduce("", stringReducerWithConnector(""))
    
    let combinedTitle = validReferences
      .map { $0.title }
      .reduce("", stringReducerWithConnector(", "))
      .trim(", ")
    
    let combinedFilter = movieFilterWithReferences(validReferences, reducer: ||)
    
    let combinedComparator = movieComparatorWithReferences(validReferences, reducer: &&)
    
    future.completeWith(MovieListChangeReference(
      identifier: combinedIdentifier,
      title: combinedTitle,
      filter: combinedFilter,
      comparator: combinedComparator
      )
    )
  }
  
  func didTapClearButton() {
    selectedIdentifiers = [MovieListChangeIdentifier]()
  }
  
  func updateReference(_ reference: MovieListChangeReference) {
    if let index = selectedIdentifiers.index(of: reference.identifier) {
      selectedIdentifiers.remove(at: index)
    } else {
      selectedIdentifiers.append(reference.identifier)
    }
  }
}

extension MovieChangeController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return group.references.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView
      .dequeueReusableCell(withIdentifier: cellIdentifier)
      .getOrElse(UITableViewCell(style: .default, reuseIdentifier: cellIdentifier))
    
    let reference = group.references[(indexPath as NSIndexPath).row]
    
    cell.textLabel?.text = reference.title
    cell.accessoryType = selectedIdentifiers.contains(reference.identifier) ? .checkmark : .none
    
    return cell
  }
}

extension MovieChangeController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let reference = group.references[(indexPath as NSIndexPath).row]
    
    if group.multipleSelection {
      updateReference(reference)
    } else {
      future.completeWith(reference)
    }
  }
}
