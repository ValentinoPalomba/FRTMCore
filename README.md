# FRTMCore
![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)

The core framework for the FRTM Architecture, providing a simple and robust structure for your Swift projects.

## Overview

FRTMCore is a lightweight and powerful framework that provides a set of essential tools to build scalable and maintainable applications. It includes a dependency injection container, a networking layer, and architectural patterns like UseCase and Repository.

## Features

- **Dependency Injection:** A simple and powerful dependency injection container.
- **UseCase:** A protocol to define your application's use cases.
- **Repository:** A protocol to abstract data sources.
- **Networking:** A simple and functional networking layer.

## Installation

To add FRTMCore to your project, add it as a package dependency in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/your-username/FRTMCore.git", from: "1.0.0")
]
```

## Usage

### Dependency Injection

FRTMCore provides a simple dependency injection container to manage your app's dependencies.

**1. Register your dependencies:**

```swift
import FRTMCore

// Register a dependency
CoreDependencyContainer.shared.register(MyServiceProtocol.self) {
    MyService()
}
```

**2. Resolve your dependencies:**

You can resolve your dependencies using the `@Dependency` property wrapper.

```swift
import FRTMCore

class MyViewModel {
    @Dependency var myService: MyServiceProtocol
    
    func doSomething() {
        myService.doSomething()
    }
}
```

### UseCase

The `UseCase` protocol helps you to define the business logic of your application.

**1. Define a UseCase:**

```swift
import FRTMCore

protocol MyUseCaseProtocol: UseCase where Input == String, Output == String {}

class MyUseCase: MyUseCaseProtocol {
    func execute(_ input: String) throws -> String {
        return "Hello, \(input)!"
    }
}
```

**2. Use the UseCase:**

```swift
class MyViewModel {
    @Dependency var myUseCase: MyUseCaseProtocol
    
    func doSomething() {
        let result = try? myUseCase.execute("World")
        print(result) // "Hello, World!"
    }
}
```

### Repository

The `Repository` protocol helps you to abstract your data sources.

**1. Define a Repository:**

```swift
import FRTMCore

protocol MyRepositoryProtocol: Repository where Input == String, Output == String {}

class MyRepository: MyRepositoryProtocol {
    func execute(input: String) async throws -> String {
        // Your data fetching logic here
        return "Data for \(input)"
    }
}
```

**2. Use the Repository:**

```swift
class MyViewModel {
    @Dependency var myRepository: MyRepositoryProtocol
    
    func fetchData() async {
        let result = try? await myRepository.execute(input: "123")
        print(result) // "Data for 123"
    }
}
```

### Networking

FRTMCore provides a simple and powerful networking layer based on `ApiCatalog` and `NetworkManager`.

**1. Define your API endpoint:**

First, define your API endpoint by conforming to the `ApiCatalog` protocol.

```swift
import FRTMCore

struct GetUserProfile: ApiCatalog {
    typealias Input = EmptyBody
    typealias Output = UserProfile

    var host: String { "api.example.com" }
    var path: String { "/users/profile" }
    var method: HTTPMethod { .get }
    var headers: [String : String]? { nil }
}

struct EmptyBody: Codable {}

struct UserProfile: Codable {
    let id: UUID
    let name: String
    let email: String
}
```

**2. Make a request:**

Use the `NetworkManager` to make the API call. You can inject the `NetworkManager` using the `@Dependency` property wrapper.

```swift
import FRTMCore

class MyViewModel {
    @Dependency var networkManager: NetworkManager

    func fetchUserProfile() async {
        let api = GetUserProfile()
        let request = api.request(input: EmptyBody())

        do {
            let userProfile = try await networkManager.call(request)
            print("User profile: \(userProfile)")
        } catch {
            print("Error fetching user profile: \(error)")
        }
    }
}
```

## License

FRTMCore is released under the MIT license. See [LICENSE](LICENSE) for details.