//
//  ContentView.swift
//  Shared
//
//  Created by Bri on 2/10/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var githubUsers = WebServiceActor()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(githubUsers.users) { user in
                    NavigationLink {
                        UserView(user: user)
                    } label: {
                        UserLabel(user: user)
                    }
                }
            }
            .navigationTitle("Users")
        }
        .task {
            do {
                try githubUsers.getUsers()
            } catch {
                assertionFailure()
            }
        }
    }
}

struct UserLabel: View {
    
    var user: GitHubUser
    
    var body: some View {
        HStack {
            AsyncImage(url: user.avatarUrl) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Image(systemName: "person.fill")
                    .resizable()
                    .foregroundColor(.gray)
            }
            .frame(width: 64, height: 64)
            Text(user.username)
        }
    }
}

struct UserView: View {
    
    var user: GitHubUser
    
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    AsyncImage(url: user.avatarUrl)
                    Spacer()
                }
            }
            Section {
                Label(user.username, systemImage: "person.circle")
            } footer: {
                Text("User ID: ") + Text("\(user.id)")
            }
        }
        .navigationTitle(user.username)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
