//
//  ContentView.swift
//  Wallpapers
//
//  Created by yuanpengfei on 2024/3/7.
//

import SwiftUI
import Foundation
import Combine

struct ImageUrl:Decodable{
    var full:String;
    var small:String;
}

struct ImageResult :Decodable{
    var urls:ImageUrl;
    var id:String;
}

class ViewModel:ObservableObject{
    @Published var images:[ImageResult]=[]
    @Published var isLoading = false
    
    func fetchImages(){
        isLoading = true
        let url = URL(string:"https://api.unsplash.com/photos/?client_id=E3_ydb1AJ1-bJmqyNsfO85Rya5HAFnag2vLpdVGPYRA&order_by=ORDER&per_page=30")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
                  DispatchQueue.main.async {
                      self.isLoading = false
                      if let data = data {
                          do {
                              // 解码 JSON 数据
                              let decodedImages = try JSONDecoder().decode([ImageResult].self, from: data)
                              self.images = decodedImages
                          } catch {
                              print("Error decoding JSON: \(error)")
                          }
                      }
                  }
              }.resume()
    }
}



struct ContentView: View {
    @State private var searchText = ""

    @StateObject var viewModel = ViewModel()
    var body: some View {
        VStack{
            HStack{
                TextField("请输入关键词进行搜索",text: $searchText).padding(12) // 添加内边距
                    .background(Color.gray.opacity(0.2)) // 设置背景色和透明度
                    .cornerRadius(10) // 设置圆角
                    .foregroundColor(.blue) // 设置文本颜色
                    .font(.system(size: 12)) // 设置字体大小和样式
                    .border(Color.blue, width: 0) // 设置边框颜色和宽度
                    .multilineTextAlignment(.leading) // 设置多行文本对齐方式
                Spacer()
                Button(action: {
                    print("clicked")
                }){
                    Text("确定")
                                    .padding(6) // 添加内边距
                                    .background(Color.blue) // 设置背景颜色
                                    .foregroundColor(.white) // 设置文本颜色
                                    .cornerRadius(10) // 设置圆角
                }
            }.padding()
            ScrollView(.vertical, showsIndicators: false) { // 水平滚动视图，隐藏滚动条
                        VStack(spacing: 20) { // 水平堆叠
                            ForEach(viewModel.images,id: \.id) { imageItem in
                                AsyncImage(url: URL(string:imageItem.urls.small)) { image in
                                    // 成功加载图片时的视图
                                    image.resizable()
//                                         .scaledToFit()
                                } placeholder: {
                                    // 图片加载时的占位视图
                                    ProgressView()
                                }
                                .frame(width: 300, height: 400) // 设置图片框架大小
                                .cornerRadius(20) // 设置图片圆角 设置图片圆角
                            }
                        }
                        .padding() // 添加内边距
                    }
            
          

                   
            
        }.onAppear{
            viewModel.fetchImages()
        }
    }
  
}

#Preview {
    ContentView()
}
