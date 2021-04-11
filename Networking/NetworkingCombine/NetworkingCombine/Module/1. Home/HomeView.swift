//
//  HomeView.swift
//  List-Navigation Demo
//
//  Created by MBA0321 on 3/5/21.
//

import SwiftUI
import Introspect
import MobileCoreServices

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    @State private var foodDetailActive: Bool = false
    @State private var trendingActive: Bool = false
    @State private var editMode = EditMode.inactive

    
    init(viewModel: HomeViewModel = HomeViewModel()) {
        print("Home View Created")
        _viewModel = StateObject<HomeViewModel>(wrappedValue: viewModel)
        configUI()
    }

    private func configUI() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = .clear
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.168627451, blue: 0.3215686275, alpha: 1)
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.9137254902, green: 0.168627451, blue: 0.3215686275, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.navibarColor
                    .ignoresSafeArea()
                List {
                    sectionSearchView
                    sectionTrendingView
                    sectionPopularView
                }
                .listStyle(GroupedListStyle())
                .pullToRefresh(isShowing: $viewModel.isShowing, onRefresh: {
                    viewModel.currentPopularPageIndex.send(1)
                })
                .navigationBarItems(leading: editButton, trailing: filterButton)
                .environment(\.editMode, $editMode)
                .navigationTitle("Browse")
                .navigationBarTitleDisplayMode(.large)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            }
        }
    }
    
    private func deleteRow(at indexSet: IndexSet) {
        viewModel.popularRestaurants.remove(atOffsets: indexSet)
    }

    private func onMove(source: IndexSet, destination: Int) {
        viewModel.popularRestaurants.move(fromOffsets: source, toOffset: destination)
    }
}

extension HomeView {
    
    private var searchView: some View {
        HomeSearchView(textSearch: .constant(""))
            .reloadData {
                // Action
            }
    }
    
    private var sectionSearchView: some View {
        Section(header: searchView) { }
            .listRowInsets(EdgeInsets())
            .background(Color.white)
    }
    
    private var sectionTrendingView: some View {
        Section(header: HStack {
            Text("Trending this week")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title3)
            NavigationLink(destination: TrendingView(isActive: $trendingActive),
                isActive: $trendingActive,
                label: {
                    Text("View all >>")
                        .foregroundColor(Color.navibarColor)
                        .bold()
                }).buttonStyle(PlainButtonStyle())
        }
        .padding([.bottom])
        ) {
            ScrollView(.horizontal, showsIndicators: true) {
                LazyHStack(spacing: 0, content: {
                    ForEach(viewModel.trendingRestaurants) { item in
                        NavigationLink(
                            destination: FoodDetailsView(isActive: $foodDetailActive),
                            isActive: $foodDetailActive,
                            label: {
                                TrendingCell(viewModel: TrendingCellViewModel(item: item))
                                    .padding([.trailing, .bottom, .top], 20)
                                
                            }).buttonStyle(PlainButtonStyle())
                    }
                })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
    }
    
    private var sectionPopularView: some View {
        Section(header: HStack {
            Text("Most popular")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title3)
            NavigationLink(
                destination: TrendingView(isActive: $trendingActive),
                isActive: $trendingActive,
                label: {
                    Text("View all >>")
                        .foregroundColor(Color.navibarColor)
                        .bold()
                }).buttonStyle(PlainButtonStyle())
        }
        .padding([.bottom])
        ) {
            ForEach(viewModel.popularRestaurants) { item in
                ZStack {
                    NavigationLink(
                        destination: FoodDetailsView(isActive: $foodDetailActive),
                        isActive: $foodDetailActive,
                        label: {
                            EmptyView()
                        }
                    )
                    .listRowBackground(Color.red)
                    .opacity(0.0)
                    MostPopularCell(restaurant: item)
                        .padding([.top, .bottom], 20)
                        .onAppear(perform: {
                            viewModel.checkPopuplarLoadmoreNeeded(item)
                        })
                }
            }
            .onDelete(perform: deleteRow(at:))
            .onMove(perform: onMove(source:destination:))
            .onInsert(of: [String(kUTTypeURL)], perform: onInsert)
            .gesture(DragGesture()
                        .onChanged({ (value) in
                            viewModel.hasScroll = true
                        })
                        .onEnded({ (value) in
                            print(value)
                        })
            )
            if viewModel.canLoadMore && !viewModel.popularRestaurants.isEmpty {
                LazyVStack(alignment: .center) {
                    ProgressView()
                }
            }
        }
        .background(Color.white)
    }
    
    @ViewBuilder
    private var filterButton: some View {
        switch editMode {
        case .inactive:
            Text("Filter")
                .font(.title2)
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
        default:
            EmptyView()
        }
    }
    
    private var editButton: some View {
        EditButton()
            .font(.title2)
            .multilineTextAlignment(.leading)
            .foregroundColor(.white)
    }
    
    private func onInsert(at offset: Int, itemProvider: [NSItemProvider]) {
        for provider in itemProvider {
            // 1.
            if provider.canLoadObject(ofClass: URL.self) {
                // 2.
                _ = provider.loadObject(ofClass: URL.self) { url, error in
                    DispatchQueue.main.async {
                        // 3.
//                        url.map { self.items.insert(Item(title: $0.absoluteString), at: offset) }
                    }
                }
            }
        }
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
