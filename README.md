# Pokémon App - iOS Technical Test

This is a simple app that lists Pokémon and shows their details, powered by the PokéAPI.

This project was built for a technical test, with a focus on demonstrating clean software architecture, best practices, and testing.

---

## 🚀 How to Run

* **Prerequisites:** Xcode 15+ and an iOS 15+ simulator.

1.  Clone the repository.
2.  Open the `PokemonApp.xcodeproj` file.
3.  Press **Cmd + R** to run the app.
4.  Press **Cmd + U** to run the tests.

---

## 🏗️ Architecture and Decisions

The foundation of the project is **Clean Architecture**. I chose this approach to keep the code well-organized, with a clear separation of concerns, and, most importantly, easy to test.

The app is divided into 3 layers:

* **Presentation:** What the user sees (the screens, built with ViewCode).
* **Domain:** The "brain" of the app, containing the business logic (what a Pokémon is, what the app does).
* **Data:** The layer that fetches data from the internet.

Within this structure, I made a few key decisions:

* **MVVM-C (Model-View-ViewModel + Coordinator):** I used **MVVM** for the UI, with Apple's **Combine** framework to bind the visual part (`View`) to its logic (`ViewModel`). For navigation, I used the **Coordinator** pattern, which centralizes the app's flow and keeps the screens independent.

* **Repository and Use Cases:** For the data logic, the **Repository** pattern hides the API's implementation details. **Use Cases** organize each action the user can perform, such as "fetch the list of Pokémon," keeping the code clean and with single responsibilities.

---

## 🛠️ Tools & Libraries

I opted to use Apple's native frameworks as much as possible to demonstrate knowledge of the platform.

* **UIKit (100% ViewCode):** To build the UI entirely in code, which provides more control and simplifies maintenance.
* **Combine & URLSession:** For reactivity and networking, using Apple's modern, native APIs.
* **XCTest:** For unit and UI tests, ensuring the app's core logic works as expected.

---

## 📈 Future Improvements

If I had more time, the next steps would be:

* Implement **pagination** on the list (infinite scroll) to load more Pokémon.
* Add a **local cache** for offline support.
* Improve the user experience with more elegant **loading screens (skeleton views)**.
* **Modularize** the project by separating the layers into Swift Packages to improve scalability.
