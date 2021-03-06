//
//  HomeView.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//

import SwiftUI

struct HomeView: View {
    @State var selectedTab = "home"
    @State var upload: Bool = false
    
    @StateObject var notify: NotifyViewModel = NotifyViewModel()
    
    //MARK: Publication screens
    @StateObject var publicationPresent: PublicationViewModel = PublicationViewModel()
    
    //MARK: Bottom Sheets present
    @StateObject var bottomSheetViewModel : BottomSheetViewModel = BottomSheetViewModel()
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            //MARK: Publication screens view
            NavigationLink(destination: PublicationTextPostView()
                            .environmentObject(notify).ignoreDefaultHeaderBar, isActive: $publicationPresent.presentPublicationTextPostView) { EmptyView() }
            
            NavigationLink(destination: PublicationMediaPostView()
                            .environmentObject(notify)
                            .environmentObject(publicationPresent).ignoreDefaultHeaderBar, isActive: $publicationPresent.presentPublicationMediaPostView) { EmptyView() }
            
            NavigationLink(destination: Text("presentPublicationStoryView").ignoreDefaultHeaderBar, isActive: $publicationPresent.presentPublicationStoryView) { EmptyView() }
            TabView(selection: $selectedTab){
                FeedView()
                    .environmentObject(notify)
                    .environmentObject(bottomSheetViewModel)
                    .ignoresSafeArea(SafeAreaRegions.container, edges: .bottom)
                    .ignoreDefaultHeaderBar
                    .tag("home")
                SearchView()
                    .environmentObject(bottomSheetViewModel)
                    .ignoreDefaultHeaderBar
                    .tag("search")
                ActivitiesView()
                    .ignoreDefaultHeaderBar
                    .tag("activities")
                ProfileView(userId: UserDefaults.standard.string(forKey: "userId")!)
                    .ignoreDefaultHeaderBar
                    .environmentObject(bottomSheetViewModel)
                    .tag("profile")
            }
            
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                if self.upload {
                    BlurView(style: .light)
                        .opacity(0.8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea(.all, edges: .all)
                        .onTapGesture {
                            withAnimation {
                                self.upload = false
                            }
                        }
                }
                Tabbar(selectedTab: $selectedTab, upload: self.$upload)
                    .environmentObject(publicationPresent)
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .bottomSheet(isPresented: self.$bottomSheetViewModel.isShareBottomSheet, height: UIScreen.main.bounds.height / 2, topBarCornerRadius: 16, showTopIndicator: true, corners: false) {
            ShareBottomSheet()
        }
        .bottomSheet(isPresented: $bottomSheetViewModel.profileSettingsBottomSheet, height: UIScreen.main.bounds.height / 1.6, topBarCornerRadius: 16, corners: true) {
            ProfileSettinsBottomSheet().environmentObject(bottomSheetViewModel)
        }
        .bottomSheet(isPresented: $bottomSheetViewModel.postBottomSheet, height: UIScreen.main.bounds.height / 2, topBarCornerRadius: 16, corners: false) {
            PostBottomSheetContent().environmentObject(bottomSheetViewModel)
        }
        .bottomSheet(isPresented: $bottomSheetViewModel.presentAddPublication, height: UIScreen.main.bounds.height / 2.2, topBarCornerRadius: 16, corners: false) {
            AddPublicationBottomSheetContent()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ShareBottomSheet()
    }
}

struct AddPublicationBottomSheetContent: View {
    let sepparatorGradient: LinearGradient = LinearGradient(colors: [Color(hex: "#C4C4C4").opacity(0), Color(hex: "#C4C4C4"), Color(hex: "#C4C4C4").opacity(0)], startPoint: .leading, endPoint: .trailing)
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("????????????????")
                    .font(.custom(GothamBold, size: 20))
                    .foregroundColor(Color(hex: "#2E313C"))
                    .textCase(.uppercase)
                Spacer(minLength: 0)
                Button(action: {}) {
                    Image("roundedRectanglePlus")
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 34)
            self.sepparator()
            self.addPublicationItem(icon: "publication", title: "????????????????????")
            self.sepparator()
            self.addPublicationItem(icon: "post", title: "????????")
            self.sepparator()
            self.addPublicationItem(icon: "story", title: "??????????????")
            self.sepparator()
            self.addPublicationItem(icon: "actualStory", title: "???????????????????? ???? ??????????????")
            self.sepparator()
        }
    }
    @ViewBuilder
    private func sepparator() -> some View {
        Rectangle()
            .fill(sepparatorGradient)
            .frame(height: 1)
    }
    @ViewBuilder
    private func addPublicationItem(icon: String, title: String) -> some View {
        Button(action: {}) {
            HStack(spacing: 0) {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 23, height: 23)
                    .padding(.trailing, 14)
                Text(title)                     .font(.custom(GothamBook, size: 16))
                    .textCase(.uppercase)
                    .foregroundColor(.black)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
        }
    }
}


struct PostBottomSheetContent: View {
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                CustomButtonPostSheet(title: "????????????????????", image: "share_bottom_sheet")
                CustomButtonPostSheet(title: "????????????", image: "link_bottom_sheet")
                CustomButtonPostSheet(title: "????????????????????????", image: "report_bottom_sheet")
            }
            .padding(.bottom)
            VStack {
                Spacer(minLength: 0)
                Button(action: {}) {
                    VStack(spacing: 0) {
                        Text("???????????????? ?? ??????????????????")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                            .padding(.bottom, 15)
                        Rectangle()
                            .fill(Color(hex: "#D8D2E5").opacity(0.25))
                            .frame(width: UIScreen.main.bounds.width - 42, height: 1)
                    }
                }
                .padding(.bottom, 13)
                Button(action: {}) {
                    VStack(spacing: 0) {
                        Text("????????????")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                            .padding(.bottom, 15)
                        Rectangle()
                            .fill(Color(hex: "#D8D2E5").opacity(0.25))
                            .frame(width: UIScreen.main.bounds.width - 42, height: 1)
                    }
                }
                .padding(.bottom, 13)
                Button(action: {}) {
                    VStack(spacing: 0) {
                        Text("???????????????? ????????????????")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                            .padding(.bottom, 15)
                        Rectangle()
                            .fill(Color(hex: "#D8D2E5").opacity(0.25))
                            .frame(width: UIScreen.main.bounds.width - 42, height: 1)
                    }
                }
                Spacer(minLength: 0)
            }
            .frame(width: (UIScreen.main.bounds.width - 42))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#FAFAFA"))
                    .modifier(RoundedEdge(width: 1, color: Color(hex: "#DFDFDF"), cornerRadius: 10))
            )
        }
        .padding(.bottom, 24)
        .padding(.top, 43)
    }
    @ViewBuilder
    func CustomButtonPostSheet(title: String, image: String) -> some View {
        Button(action: {}) {
            VStack {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .padding(.bottom, 1)
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.black)
            }
        }
        .frame(width: (UIScreen.main.bounds.width - 42) / 3.2, height: ((UIScreen.main.bounds.width - 78) / 3) / 1.5, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "#FAFAFA"))
                .modifier(RoundedEdge(width: 1, color: Color(hex: "#DFDFDF"), cornerRadius: 10))
        )
    }
}

struct ShareBottomSheet : View {
    @State var searchText: String = ""
    var body : some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("????????????????????")
                    .textCase(.uppercase)
                    .font(.custom(GothamBold, size: 23))
                    .foregroundColor(Color(hex: "2E313C"))
                Spacer(minLength: 0)
                Button(action: {}) {
                    Image("share.square")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.bottom, 25)
            
            HStack(spacing: 0) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(hex: "#444A5E"))
                    .padding(.trailing, 8)
                TextField("??????????", text: self.$searchText)
            }
            .padding(.horizontal, 17)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10.0)
                    .strokeBorder(Color(hex: "#DDE8E8"), style: StrokeStyle(lineWidth: 1.0))
                    
            )
            .padding(.bottom, 38)
            
            ForEach(0..<2, id: \.self) {_ in
                HStack(spacing: 16) {
                    ForEach(0..<4, id:\.self) {_ in
                        Button(action: {}) {
                            VStack(spacing: 0) {
                                Image("testUserPhoto")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 54, height: 54)
                                    .cornerRadius(10)
                                    .padding(.bottom, 12)
                                Text("Lana Smith")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "#444A5E"))
                            }
                        }
                    }
                }
                .padding(.bottom, 17)
            }
            
            Button(action: {}) {
                Text("??????????????????")
                    .font(.custom(GothamMedium, size: 14))
                    .foregroundColor(.white)
            }
            .frame(width: 130, height: 56)
            .background(
                LinearGradient(colors: [Color(hex: "#5B86E5"), Color(hex: "#36DCD8")], startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(40)
        }
        .padding(.horizontal, 32)
    }
}

private struct ProfileSettinsBottomSheet : View {
    @EnvironmentObject var bottomSheetViewModel: BottomSheetViewModel
    var body : some View {
        
        VStack {
            Button(action: {}) {
                HStack {
                    Image("your_activity")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    Text("???????? ????????????????????")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#2E313C"))
                    Spacer(minLength: 0)
                }
                .padding()
            }
            NavigationLink(destination: SavedView()
                            .ignoreDefaultHeaderBar) {
                HStack {
                    Image("saves")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    Text("??????????????????????")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#2E313C"))
                    Spacer(minLength: 0)
                }
                .padding()
            }
            .simultaneousGesture(TapGesture().onEnded{
                bottomSheetViewModel.profileSettingsBottomSheet = false
            })
            Button(action: {}) {
                HStack {
                    Image("favorite")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    Text("?????????????? ????????????")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#2E313C"))
                    Spacer(minLength: 0)
                }
                .padding()
            }
            Button(action: {}) {
                HStack {
                    Image("add_friend")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    Text("???????????????????? ????????")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#2E313C"))
                    Spacer(minLength: 0)
                }
                .padding()
            }
            Button(action: {}) {
                HStack {
                    Image("edit_profile")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    Text("?????????????????????????? ??????????????")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#2E313C"))
                    Spacer(minLength: 0)
                }
                .padding()
            }
            Spacer(minLength: 0)
            NavigationLink(destination: SettingsView().ignoreDefaultHeaderBar) {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color(hex: "#F2F2F2"))
                        .frame(height: 1)
                    HStack {
                        Image("settings")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                        Text("??????????????????")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#2E313C"))
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
            }
            .simultaneousGesture(TapGesture().onEnded{
                bottomSheetViewModel.profileSettingsBottomSheet = false
            })
        }
    }
}

struct Tabbar : View {
    @EnvironmentObject var publicationPresent: PublicationViewModel
    
    @Binding var selectedTab: String
    @Binding var upload: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            TabbarButton(image: "home_inactive", image_active: "home_active", action: {
                onPressTab(tab: "home")
            }, isActive: selectedTab == "home" && !self.upload)
            Spacer(minLength: 0)
            TabbarButton(image: "search_inactive", image_active: "search_active", action: {
                onPressTab(tab: "search")
            }, isActive: selectedTab == "search" && !self.upload)
            Spacer(minLength: 0)
            TabbarButton(image: "plus_fill_inactive", image_active: "plus_fill_active", action: {
                withAnimation(.spring()) {
                    self.upload.toggle()
                }
            }, isActive: self.upload)
            Spacer(minLength: 0)
            TabbarButton(image: "alarm_inactive", image_active: "alarm_active", action: {
                onPressTab(tab: "activities")
            }, isActive: selectedTab == "activities" && !self.upload)
            Spacer(minLength: 0)
            TabbarButton(image: "profile_inactive", image_active: "profile_active", action: {
                onPressTab(tab: "profile")
            },isActive: selectedTab == "profile" && !self.upload)
        }
        .frame(height: 50)
        .padding(.horizontal, 30)
        .padding(.vertical)
        .background(Color.white.cornerRadius(12))
        .padding(.horizontal)
        .padding(.vertical)
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        .overlay(
            UploadView(show: self.$upload).environmentObject(publicationPresent),
            alignment: Alignment(horizontal: .center, vertical: .top)
        )
    }
    
    func onPressTab (tab: String) {
        withAnimation(.spring()) {
            if self.upload {
                self.upload = false
            }
            self.selectedTab = tab
        }
    }
    
}

struct TabbarButton: View {
    var image: String
    var image_active: String
    var action: () -> Void
    var isActive: Bool
    
    static let color0 = Color(red: 92/255, green: 249/255, blue: 192/255);
    static let color1 = Color(red: 50/255, green: 184/255, blue: 248/255);
    static let color2 = Color(red: 137/255, green: 93/255, blue: 242/255);
    let gradient = Gradient(colors: [Color(hex: "#5B86E5"), Color(hex: "#36DCD8")]);
    var body: some View {
        GeometryReader{proxy in
            Button(action: self.action) {
                VStack(spacing: 0) {
                    Image(isActive ? image_active : image)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .background(
                            ZStack {
                                if isActive {
                                    ZStack{}.frame(width: 50, height: 50)
                                        .background(LinearGradient(
                                            gradient: gradient,
                                            startPoint: .init(x: 1.00, y: 0.46),
                                            endPoint: .init(x: 0.00, y: 0.54)
                                          ))
                                        .clipShape(Circle())
                                        .shadow(radius: 20 )
                                }
                            }
                            .frame(width: 50, height: 50)
                        )
                        .offset(y: isActive ? -35 : 0)
                    if isActive {
                        Circle()
                            .fill(Color(hex: "#3EACF7"))
                            .frame(width: 10, height: 10)
                            .offset(y: -15)
                    }
                }.frame(width: 60)
            }
        }
        .frame(height: 30)
    }
}

struct BlurView: UIViewRepresentable {

    let style: UIBlurEffect.Style

    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(Color(hex: "#D8D2E5").opacity(0.25))
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }

    func updateUIView(_ uiView: UIView,
                      context: UIViewRepresentableContext<BlurView>) {

    }
}

struct UploadView : View {
    @EnvironmentObject var publicationPresent: PublicationViewModel
    @Binding var show: Bool
    
    public init (show: Binding<Bool>) {
        self._show = show
    }
    
    var body : some View {
        if show {
            HStack {
                VStack {
                    Text("??????????????????")
                        .foregroundColor(Color(hex: "#333333"))
                        .textCase(.uppercase)
                        .padding(.top, 15)
                    Spacer(minLength: 0)
                    HStack(spacing: 18) {
                        Button(action: {
                            self.show = false
                            publicationPresent.presentPublicationMediaPostView = true
                        }) {
                            UploadButtonView(icon: "gallery_icon", title: "????????")
                        }
                        Button(action: {
                            self.show = false
                            publicationPresent.presentPublicationTextPostView = true
                        }) {
                            UploadButtonView(icon: "message_icon", title: "????????")
                        }
                        Button(action: {
                            
                        }) {
                            UploadButtonView(icon: "video_icon", title: "??????????????")
                        }
                    }
                    .padding(.bottom, 34)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 70, height: 164, alignment: .center)
            .background(Color.white)
            .cornerRadius(27.0)
            .overlay(
                Triangle()
                    .fill(Color.white)
                    .frame(width: 22, height: 15, alignment: .center)
                    .rotationEffect(.init(degrees: 180))
                    .offset(y: 15),
                alignment: Alignment(horizontal: .center, vertical: .bottom)
            )
            .offset(y: -194)
        } else {
            Color.clear
        }
    }
}

struct UploadButtonView : View {
    private let icon : String
    private let title : String
    
    public init (icon: String, title: String) {
        self.icon = icon
        self.title = title
    }
    
    var body: some View {
        ZStack {
            VStack {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .shadow(color: .black, radius: 20, x: 0.0, y: 15.0)
                Text(title)
                    .foregroundColor(Color(hex: "#4F4F4F"))
                    .font(.system(size: 12))
                    .textCase(.uppercase)
            }
            .padding()
            .frame(maxWidth: ((UIScreen.main.bounds.width - 90) / 3) - 20)
        }
        .background(Color(hex: "#F3F3F3"))
        .cornerRadius(14)
        .frame(maxWidth: ((UIScreen.main.bounds.width - 90) / 3) - 20, maxHeight: 164 / 2)
    }
}

struct Triangle: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    path.move(to: CGPoint(x: rect.midX, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
    
    path.closeSubpath()
    
    return path
  }
}
