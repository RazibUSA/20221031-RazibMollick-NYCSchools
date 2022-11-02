//
//  ViewController.swift
//  20221031-RazibMollick-NYCSchools
//
//  Created by Razib Mollick on 10/29/22.
//

import UIKit

enum Section {
    case main
}

// MARK: - View Controller
class HighSchoolListViewController: UIViewController {
    
    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<Section, HighSchoolNameModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, HighSchoolNameModel>
    
    private lazy var collectionView: UICollectionView = {
        let layout = setupCollectionViewLayout()
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = .lightGray
        return collection
    }()
    
    let cellId = "nameCellId"
    let coordinator: HighSchoolListCoordinator
    private lazy var dataSource: DataSource = makeDataSource()
    private var searchController = UISearchController(searchResultsController: nil)
    private lazy var viewModelDataSource: HighSchoolNamesDataSource = HighSchoolNamesDataSource()
    
    init(coordinator: HighSchoolListCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .clear
        configureSearchController()
        configureViews()
        makeRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "NYC High Schools"
        
    }
}

private extension HighSchoolListViewController {
    func makeDataSource() -> DataSource {
        return DataSource(collectionView: collectionView, cellProvider: { [self] (collectionView, indexPath, schoolNameModel) -> UICollectionViewCell? in
            let cell: HighSchoolNameCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HighSchoolNameCollectionViewCell
            cell.schoolName = schoolNameModel.school_name
            
            return cell
        })
    }
    
    func applySnapShot(schoolList: [HighSchoolNameModel], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(schoolList)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    func configureViews() {
        collectionView.register(HighSchoolNameCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        self.setupCollectionView()
    }
    
    func setupCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _, environment -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(60))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.interGroupSpacing = 5
            
            return section
        }
        return layout
    }
    
    func makeRequest() {
        
        viewModelDataSource.requestSchoolNames { [weak self] error in
            guard let self = self else { return }
            
            if let error = error as? AppError {
                //TBD
                debugPrint(error.description)
                return
            }
            
            DispatchQueue.main.async {
                self.applySnapShot(schoolList: self.viewModelDataSource.dataSource)
            }
        }
    }
}

extension HighSchoolListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TO-DO: -
    }
    
    func configureSearchController() {
      searchController.searchResultsUpdater = self
      searchController.obscuresBackgroundDuringPresentation = false
      searchController.searchBar.placeholder = "Search School Name"
      navigationItem.searchController = searchController
      definesPresentationContext = true
    }
}
