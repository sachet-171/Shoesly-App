
Firsly i download a dart with version 3.2.3 (stable) and download a flutter with version 3.20.0-1.2.pre from https://docs.flutter.dev/get-started/install then made a project name shoeslymain then i provide sdk for this flutter applcation location. flutter application is open from view command palette , then the platfom is created. I enable cupertino_icons,carousel_sliderfirebase_core,cloud_firestore,provider,shared_preferences,flutter_rating_bar etc .

1.Project setup instruction

-clone my repository then open the folder with vs code,Andorid each things you have then -Setup Flutter: Ensure Flutter SDK is installed. If not, follow the Flutter installation guide. Run flutter doctor to check if all dependencies are correctly installed.

-Firebase Configuration: Create a Firebase project from the Firebase Console. In my project i named as shoeslymain Add Android and iOS apps to your Firebase project. Download google-services.json for Android and GoogleService-Info.plist for iOS, and place them in the respective directories (android/app for Android, ios/Runner for iOS).as of mine you can look up in code

-update dependencies using flutter pub get or you can change from pubsec.yaml. -run the application in android,ios mobile or emulator

2.Assumptions Made During Development

During development of Shoeslymain, the following assumptions were made:

-The Firebase project is set up with necessary Firestore collections and documents to store shoe data, user reviews, and orders,price,productId,brand,specialforyour,description etc -Firebase Functions or similar services are used to compute and store average review scores for products.With stars provided user can filter the products also -The UI/UX design is closely followed as provided in the Figma designs and favrouite click products are stored in favrouite buttom navigation also -Error handling is implemented for API requests and Firebase operations. -when add to cart perfrom it pass the content like name price, quantity,image,size in cart and cart perform create and delete operation -while place order , the details of product,user location will be upload in firebase. -No real payment integration is required for checkout -All the data must be fetched from firebase and carousel work nicely and filter of product with the brands name -list of product must be there which call the prodct from all collection of firebasedatabase and search prodcut filter will make user more easier and convinent

3.Challenges Faced and How They Were Overcome

-Firebase Integration: Ensuring seamless integration with Firebase for data storage and real-time updates posed initial challenges in setting up Firestore listeners and data models. Overcame by carefully structuring Firestore documents and using StreamBuilders for real-time data updates.

-UI Responsiveness: Achieving a fully responsive UI across different devices and screen sizes required meticulous adjustment of layout constraints and breakpoints. Regular testing on multiple devices and emulators helped to refine responsiveness.

-Filtering and Sorting Logic: Implementing complex filtering and sorting options (e.g., by brand, price range, reviews) while maintaining performance and code readability was challenging. Utilized Firebase queries effectively and optimized data fetching strategies.

-search in list of product where i overcome with multiple help from websites ,dedication to code etc -filter with star rating and overcome with fluteer_rating_bar dependencies

4.Additional Features or Improvements Added

-making of list of product,fetched all the data from all collection in firebase database -Added a search feature to allow users to search for shoes by name, -used of sharedprefences in list to cart for store data long lasting and used cart.clear to clear the cart when product is placed order -used of filter with starRating -use of Quantity increment/decrement meter in detailscreen -making paragraph in socrollposition -making favrouite option in nav bar when user click to fav to any product it store inbotton navigation bar favrouite section -making cart in botton navigation bar and filter in botton navigation bar too -additional of grandtoal in cartpage where quantity meter increase grandtotal increase/decrease -can used multiple product in cart and total price is generated of multiple cards as grandotal -Utilized Firebase Analytics to gain insights into user behavior and app performance.

5.Code Quality

To ensure high code quality:

-Followed Flutter best practices and architectural patterns ( Provider). Modularized code into reusable widgets and classes. Used consistent coding styles and meaningful variable/function names. Commented on everypage of dart complex logic and used documentation comments where necessary.

By following these practices and enhancements, ShoeslyMain delivers a robust and user-friendly mobile shopping experience for shoe enthusiasts, leveraging the power of Flutter and Firebase technologies.
