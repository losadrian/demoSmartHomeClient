In this Proof of Concept project I’d like to provide a quick overview of my preferred architectural pattern which could be useful to work in a team, and it can be also very handy in complex solo projects.

I've created a working sample application that I can use to write my articles. Overview of structure could be a good start in the first part of a possible series.

I'm still experimenting on software architecture techniques and if you also have several years of coding experience behind you probably could realise there is No Silver Bullet at all in any case neither in software development nor in other areas of life.

Design patterns like factory, builder, delegate, etc. can be found in many projects using them almost the same way because they can handle problems of localised logical units in a small section of the code base.

On the other hand the architectural patterns define how components have to work and communicate in the code base. It is worth choosing wisely which one could fit to your project at the planning part, because it is very hard to change your mind later when the sprints come.

I've read about architectural patterns including MVC, MVP, MVVM, VIPER, VIP etc. and as I've seen in many articles MVC has become a deprecated pattern compared to MVVM, VIPER and other fancy pattern. While I was studying these patterns, I felt they all had something in common. If the project is not only a completely data-driven thin client, but also contains complex business logic, one of the pattern's layers (controller, presenter, viewmodel, interactor etc.) starts to get very thick sooner or later even if you use other than MVC.

I was trying to reinvent the wheel when I found Clean Code and Clean Architecture by Robert C. Martin and I started to read an another awesome book named Advanced iOS App Architecture by Josh Berlin & René Cacheaux.

The usage of MVVM pattern separately sticked to the presentation logic and the arrangement of the business logic in a domain structure seem to be a solution for the layer obesity.

Lot of great articles can be found on the internet to discuss clean architecture in more detail. This one doesn't want to be one of them, so just in short:

A clean architecture should consist of different layers: Presentation, Data and Domain.
- Presentation layer should contain the UI codes with one of MV(X) pattern that is preferred by you and in which one the views are calling methods, bindig datas from controllers, presenters, viewmodels, interactors etc. and managed by them. 
- Data layer should contain the data sources which could be one or more, local (persistent like Core Data, or cached) or remote. The mappers of network DTOs to Domain or Core Data models should be included in this layer if the project requires them. 
- Domain layer should only contain its entities and the pure business logic wrapped in Use Cases. It also should contain Data Repositories Interfaces which abstractions are needed for to make and pure independent layer. Dependencies to other layers, including external 3rd party libraries should be avoided in this layer.

This project is grouped according to the layers which you can read above. The Application folder contains only iOS specific files and some utility codes, for example helpers in ExtensionLibrary, Dependency Injection factory, enums, errors and resources.

I definitely prefer using industry standard tools and yes I am one of those iOS developers who are indeed snobs when it comes to using third-party libraries (I have my own reason and experience. ^_^""). Although I do not avoid using them in rational cases. It is particularly difficult to solve a Facebook or Google login without them. Because I didn't want to kill a mosquito with a bazooka I wrote my own network management layer.
I'd like to show a way to create REST architectural style specific networking layer with the Builder pattern in this PoC project. The builder pattern is a creational design pattern. You can construct complex objects step by step instead of create a huge constructor.

I've learnt Builder pattern from Effective Java by Joshua Bloch and I needed to use it very often when I was a Java EE developer. However, I haven't felt the urge to use it beside of patterns as factory, singleton, delegate and so on, since I had an opportunity to join our iOS team and I started to learn iOS development 

In this networking layer I use the Combine framework to fetch data. Lucky for us Apple has added publishers to network data transfer API as they also did with their other own asynchronous APIs.

The Dependency Injection is an another important key in that project that should be mentioned. Classes shouldn't create their own dependencies. 
To make the classes independent of this task a dependency container object was made that can inject the dependencies into the classes' own constructors.

Unfortunately, this PoC project does not have tests and it was not created using the TDD method. Should not write production code without tests. The clean code makes the project testable as well. This testability should be used during development, and TDD is worth a try either.

A demo server is available for this project, which was written in python and it is available at [this link](https://github.com/losadrian/demoSmartHomeServer).
If you are not interested in this part, the project can be tested by changing the build configuration in the current scheme to Mockito (I came from Java world ^_^").

Resources:
- https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
Clean Architecture, and Clean Code from Robert C. Martin:
- https://www.amazon.com/Robert-C-Martin/dp/0134494164
- https://www.amazon.com/Robert-C-Martin/dp/B001GSTOAM
Advanced iOS App Architecture by Josh Berlin & René Cacheaux
- https://www.kodeco.com/books/advanced-ios-app-architecture


//TODO: Use Apple new asynchronous (async) functions and write tests.
