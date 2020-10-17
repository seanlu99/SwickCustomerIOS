//
//  ImageLoader.swift
//  Swick
//  
//  Taken from https://github.com/V8tr/AsyncImage
//

import SwiftUI
import Combine
import Foundation

class ImageLoader: ObservableObject {
    // Properties
    @Published var image: UIImage?
    private let url: URL

    init(url: URL) {
        self.url = url
        self.image = UIImage(named: "placeholder")
    }

    deinit {
        cancel()
    }
    
    private var cancellable: AnyCancellable?

    func load() {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}

struct AsyncImage: View {
    @ObservedObject private var loader: ImageLoader

    init(url: String) {
        _loader = ObservedObject(wrappedValue: ImageLoader(url: URL(string: url)!))
    }

    var body: some View {
        content
            .onAppear(perform: loader.load)
    }
    
    private var content: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
            } else {
                Text("Loading...")
            }
        }
    }

}

struct AsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImage(url: "https://swick-assets.s3.amazonaws.com/media/cozydiner.jpg")
    }
}
