//
//  CollectionView.swift
//  ScrollTestSwiftui
//
//  Created by atakishiyev on 4/14/24.
//

import SwiftUI

enum Section {
    case main
}

class CustomListCoordindator: NSObject {
    var parent: CustomCollectionView
    var dataSource: UICollectionViewDiffableDataSource<Section, Photo>!
    var viewModel: PhotoViewModel
    var task: Task<Void, Error>?
    
    init(_ parent: CustomCollectionView, viewModel: PhotoViewModel) {
        self.viewModel = viewModel
        self.parent = parent
        super.init()
    }
    
    func applySnapshot(using items: [Photo], animated: Bool) {
        var currentSnapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(items, toSection: .main)
        dataSource.apply(currentSnapshot, animatingDifferences: animated)
    }
    
    deinit {
        task?.cancel()
    }
}

extension CustomListCoordindator: UIScrollViewDelegate, UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        // Check if the user has scrolled to the bottom
        if offsetY > contentHeight - frameHeight - 50 {
            task = Task {
                await viewModel.getPhotos()
            }
        }
    }
}

struct CustomCollectionView: UIViewRepresentable {
    
    @Binding var items: [Photo]
    @EnvironmentObject var viewModel: PhotoViewModel
    
    func makeUIView(context: Context) -> UICollectionView {
        let layout = makeLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoItemCollectionViewCell.self, forCellWithReuseIdentifier: PhotoItemCollectionViewCell.reuseIdentifier)
        collectionView.delegate = context.coordinator
        
        let dataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoItemCollectionViewCell.reuseIdentifier, for: indexPath) as? PhotoItemCollectionViewCell else {
                return nil
            }
            cell.configure(using: item)
            return cell
        })
        
        context.coordinator.dataSource = dataSource
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            collectionView.collectionViewLayout.invalidateLayout()
        }
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: Context) {
        context.coordinator.applySnapshot(using: items, animated: true)
    }
    
    func makeCoordinator() -> CustomListCoordindator {
        CustomListCoordindator(self, viewModel: viewModel)
    }
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            var items = [NSCollectionLayoutItem]()
            
            if viewModel.items.isEmpty {
                let defaultItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
                let defaultItem = NSCollectionLayoutItem(layoutSize: defaultItemSize)
                items.append(defaultItem)
            } else {
                for photo in viewModel.items {
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(photo.imageHeight))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    items.append(item)
                }
            }
            
            let section = NSCollectionLayoutSection(group: .vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0)), subitems: items))
            section.interGroupSpacing = 10
            
            return section
        }
        
        return layout
    }
}

