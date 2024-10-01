//
//  UIImageView+Network.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//
import UIKit

extension UIImageView {
    
    func loadImage(from url: URL?, thumbnailSize: CGSize? = nil) {
        Task {
            do {
                guard let data = try await Network.downloadImage(url: url), let loadImage = UIImage(data: data) else {
                    image = nil
                    return
                }
                
                var fetchImage: UIImage? = loadImage
                
                if let thumbnailSize {
                    fetchImage = await loadImage.byPreparingThumbnail(ofSize: thumbnailSize)
                }
                
                await MainActor.run {
                    image = fetchImage ?? loadImage
                }
                
            } catch {
                throw error
            }
        }
    }
    
}
