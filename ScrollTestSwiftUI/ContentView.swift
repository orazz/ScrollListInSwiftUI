//
//  ContentView.swift
//  ScrollTestSwiftui
//
//  Created by atakishiyev on 4/14/24.
//

import SwiftUI
import Kingfisher
import LonginusSwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    @StateObject var viewModel = PhotoViewModel()
   
    var body: some View {
        
        GeometryReader { proxy in
            NavigationStack {
                Picker("Preferred Image Size", selection: $viewModel.preferredImageSize) {
                    ForEach(viewModel.imageSizeOptions, id: \.self) { size in
                        Text(size).tag(size.lowercased())
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                List(navigationItems) { item in
                    NavigationLink(value: item) {
                        Text(item.title)
                            .foregroundColor(.primary)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Scroll List")
                .navigationBarTitleDisplayMode(.large)
                .navigationDestination(for: NavigationItem.self) { item in
                        switch item.path {
                        case .kingfisher:
                            CustomListView(size: proxy.size, title: item.title,
                                           imageView: { photo in
                                KFImage(URL(string: viewModel.imageUrl(for: photo.urls)))
                                    .cancelOnDisappear(true)
                                    .downsampling(size: CGSize(width: photo.imageWidth, height: photo.imageHeight))
                                    .resizable()
                                    .placeholder { Rectangle().fill(Color.secondary) }
                                    .scaledToFill()
                                    .frame(width: photo.imageWidth, height: photo.imageHeight)
                                    .clipped()
                            }, avatarView: { photo in
                                KFImage(URL(string: photo.user.profileImage.medium))
                                    .cancelOnDisappear(true)
                                    .downsampling(size: CGSize(width: 40.0, height: 40.0))
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            })
                        case .sdWebImage:
                            CustomListView(size: proxy.size, title: item.title,
                                           imageView: { photo in
                                WebImage(url: URL(string: viewModel.imageUrl(for: photo.urls)))
                                    .cancelOnDisappear(true)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: photo.imageWidth, height: photo.imageHeight)
                                    .clipped()
                            }, avatarView: { photo in
                                WebImage(url: URL(string: photo.user.profileImage.medium))
                                    .cancelOnDisappear(true)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            })
                        case .longinus:
                            CustomListView(size: proxy.size, title: item.title,
                                           imageView: { photo in
                                LGImage(source: URL(string: viewModel.imageUrl(for: photo.urls))) {
                                   Rectangle()
                                        .frame(width: photo.imageWidth, height: photo.imageHeight)
                                }
                                .cancelOnDisappear(true)
                                .resizable()
                                .scaledToFit()
                                .frame(width: photo.imageWidth, height: photo.imageHeight)
                                .clipped()
                            }, avatarView: { photo in
                                LGImage(source: URL(string: photo.user.profileImage.medium)) {
                                    Rectangle()
                                        .frame(height: 40.0)
                                }
                                .cancelOnDisappear(true)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            })
                        case .collectioView:
                            CustomCollectionView(items: $viewModel.items).navigationBarTitle(item.title)
                        }
                    }
                
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
