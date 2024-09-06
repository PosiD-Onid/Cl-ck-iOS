//
//  OnBoardingView.swift
//  Cl!ck
//
//  Created by 이다경 on 7/23/24.
//

import SwiftUI

struct TeacherTabView: View {
    var body: some View {
        NavigationControllerWrapper(viewController: UIHostingController(rootView: TeacherTabScreenCotent()))
    }
}



#Preview {
    OnBoardingView()
}
