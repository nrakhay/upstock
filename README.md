# UpStock
**UpStock** is essentially Apple's Stocks App clone and it is written in a Swift Language by using UIKit Framework.
It was written by using the **MVC** architecture with **SOLID** and **DRY** principles

Key features of the app are:
- Searching stocks
- Adding stock to watchlist
- Reading news about stocks in the watchlist
- Ability to watch the history graph for each stock

Key technology features of the app are:
- Used **NotificationCenter** to observe changes in other View Controllers
- Implemented a **singleton API caller**, where data is fetched using **URLSession**
- Added a **Floating Panel pod** to display financial news on top of stocks watchlist
