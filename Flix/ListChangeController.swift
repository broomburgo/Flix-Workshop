
import UIKit

class ListChangeController: UIViewController {
	@IBOutlet weak var tableView: UITableView!

	fileprivate let cellIdentifier = "cellIdentifier"

	let future = Future<MovieListChange>()

	fileprivate var selectedReferences = [MovieListChangeIdentifier:MovieListChangeReference]()

	fileprivate let groups: [[MovieListChangeGroup]]
	required init(movieListChangeGroups: [[MovieListChangeGroup]]) {
		self.groups = movieListChangeGroups
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Order & Filter"
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .done,
			target: self,
			action: #selector(ListChangeController.didTapDone)
		)
		navigationItem.backBarButtonItem = UIBarButtonItem(
			title: "Cancel",
			style: .plain,
			target: nil,
			action: nil
		)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationController?.setToolbarHidden(true, animated: animated)
	}

	func didTapDone() {
		let references = Array(selectedReferences.values)
		let change = movieListChange(
			filter: movieFilterWithReferences(references, reducer: &&),
			comparator: movieComparatorWithReferences(references, reducer: &&)
		)
		future.completeWith(change)
	}
}

extension ListChangeController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return groups.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return groups[section].count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier).getOrElse(UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier))
		let group = groups[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]

		cell.accessoryType = .disclosureIndicator
		cell.textLabel?.text = group.title
		cell.detailTextLabel?.text = selectedReferences[group.identifier].map { $0.title }

		return cell
	}
}

extension ListChangeController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		let group = groups[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
		let controller = MovieChangeController(group: group)

		navigationController?.pushViewController(controller, animated: true)

		controller.future.onComplete { [unowned self] selectedReference in
			self.selectedReferences[group.identifier] = selectedReference
			self.tableView.reloadRows(at: [indexPath], with: .none)
			_ = self.navigationController?.popViewController(animated: true)
		}
	}
}


