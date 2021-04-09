# GithubClient
***iOS App that consumes Github API to fetch public repositories.*** <br/>
### Features
- [x] Fully Based on URLSessions and Written in Swift 5 using Xcode 12.1
- [x] Supports iOS 12 and newer
- [x] Uses Swift Package Manager as Dependency Manager
- [x] Does not use any 3rd parties except [JGProgressHUD](https://github.com/JonasGessner/JGProgressHUD)
- [x] Local Search
- [x] Local Pagination
- [x] Optimized Image Loading
- [x] MVP Architected
- [x] Faked Responses for test purposes
- [x] Unit Tested

<br/>

### Workarounds
The repositories endpoint does not feed you with all details demanded,<br/>
so I had to fire request for each repository to fetch details like creation date, stargazers, issues, ... <br/>
the way I did that was to fire request for each repository will be shown on the the screen (paginated 10 by 10) <br/>
synchronously one by one on a background thread then show the first 10 and that was repeated for each page got paginated.
