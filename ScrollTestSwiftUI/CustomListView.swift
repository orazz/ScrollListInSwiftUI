//
//  CustomListView.swift
//  ScrollTestSwiftui
//
//  Created by atakishiyev on 4/14/24.
//

import SwiftUI

struct CustomListView<ImageView: View, AvatarView: View>: View {
    @EnvironmentObject var viewModel: PhotoViewModel
    
    var size: CGSize
    var title: String
    let imageView: (Photo) -> ImageView
    let avatarView: (Photo) -> AvatarView
    let cardPadding: EdgeInsets = EdgeInsets(top: 0.0, leading: 10.0, bottom: 10.0, trailing: 10.0)
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .font(.subheadline)
                        .frame(height: size.height)
                } else {
                    ForEach(viewModel.items, id: \.id) { item in
                        VStack(alignment: .leading, spacing: 10) {
                            imageView(item)
                                .background(Color(uiColor: UIColor(hexString: item.color ?? "")))
                            VStack(alignment: .leading) {
                                userInfoView(item: item, avatarView: avatarView(item))
                                descriptionView(description: item.description)
                            }
                            .padding(cardPadding)
                        }
                        .frame(width: size.width)
                        .background(Color.cardBack)
                        .task {
                            if viewModel.items.isLastItem(item) {
                                await viewModel.getPhotos()
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(title)
        .task {
            await viewModel.getPhotos()
        }
    }
    
    @ViewBuilder
    private func userInfoView(item: Photo, avatarView: AvatarView) -> some View {
        HStack {
            avatarView
            Text(item.user.username ?? "")
                .font(.headline)
            Spacer()
            Text(item.createdAt.humanReadableDate())
        }
    }
    
    @ViewBuilder
    private func descriptionView(description: String?) -> some View {
        Text(description ?? "")
            .font(.subheadline)
            .lineLimit(3)
            .fixedSize(horizontal: false, vertical: true)
    }
}
