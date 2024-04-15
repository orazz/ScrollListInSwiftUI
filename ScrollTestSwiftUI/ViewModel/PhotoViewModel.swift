//
//  PhotoViewModel.swift
//  ScrollTestSwiftui
//
//  Created by atakishiyev on 4/14/24.
//

import SwiftUI

class PhotoViewModel: ObservableObject {
    @Published var items: Photos = []
    @Published var errorMessage: String = ""
    @AppStorage("preferredImageSize") var preferredImageSize: String = "small"
    
    var page = 1
    var isLoading = false
    
    let networkManager = NetworkManager()
    let imageSizeOptions: [String] = ["Thumb", "Small", "Regular", "Full", "Raw"]
    
    @MainActor
    func getPhotos() async {
        guard !isLoading else { return }
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            let photos: [Photo] = try await networkManager.fetchData(page: page)
            items.append(contentsOf: photos)
        } catch AppError.serverError(let errorMsg) {
            errorMessage = "Error fetching photos: \(errorMsg)"
        } catch {
            errorMessage = "Error fetching photos: \(error.localizedDescription)"
        }
    }
    
    func imageUrl(for urls: Urls) -> String {
        switch preferredImageSize {
            case "raw":
                // image size ~5MB
                return urls.raw
            case "full":
                return urls.full
            case "regular":
                // image sizes ~300-500KB
                return urls.regular
            case "small":
                return urls.small
            case "thumb":
                // image size ~15-20KB
                return urls.thumb
            default:
                return urls.regular
            }
    }
}
