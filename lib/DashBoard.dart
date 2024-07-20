import 'package:first/Display.dart';
import 'package:first/SqfLiteHelper/Sqflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image:AssetImage("assets/loading_screen.png"),
                  fit: BoxFit.cover
              )
          ),
          child: const Center(
              child: Text("")
          ),)
    );
  }
}

class DashBoard extends StatefulWidget {
  final String username;
  final bool isAuthor;

  DashBoard({super.key, required this.username, required this.isAuthor});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  Sqflite sqfLite = Sqflite();
  List<String> uniqueStoryNames = [];
  List<String> chars = [];
  List<bool> fav = [];
  List<String> authorNames = [];
  List<String> places = [];
  List<String> animalUrl = [
    'https://drive.google.com/uc?export=view&id=1FP6eK5sUFpOXjqDgrRNikGDa9nzP73SB',
    'https://drive.google.com/uc?export=view&id=19ar4ZAc7dyDz-FmaqJbpeh9benSKGZr0',
    'https://drive.google.com/uc?export=view&id=1jHollLgArnzjmCkUM74BaJkuJsIQGpMo'
  ];

  List<String> books = [
    "assets/book.jpg",
    "assets/book2.jpg",
    "assets/book3.jpg"
  ];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print(widget.username);
    print(widget.isAuthor);
    startSplashScreen();
  }

  void startSplashScreen() async {
    await Future.delayed(Duration(seconds: 1));
    fetchUniqueStoryNames();
  }

  void fetchUniqueStoryNames() async {
    if (widget.isAuthor) {
      uniqueStoryNames = await sqfLite.getStoryNamesByAuthor(widget.username);
    } else {
      uniqueStoryNames = await sqfLite.getAllUniqueStoryNames();
      authorNames = await sqfLite.getAllUniqueStoryNamesAuthors();
      fav = await sqfLite.getFavorite();
    }

    await getchars();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getchars() async {
    for (var s in uniqueStoryNames) {
      String r = '';
      String? charsOfEachSence = await sqfLite.getCharsOfFirstSceneByStoryName(s);
      String? pp = await sqfLite.getPlaceOfFirstSceneByStoryName(s);
      pp = await sqfLite.getUrlByPlaceName(pp!);

      places.add(pp!);

      List<String> q = convertStringToList(charsOfEachSence!);
      for (var s in q) {
        String w = await sqfLite.getUrlByAnimalName(s!);
        r = r + w + ',';
      }
      chars.add(r);
    }
    setState(() {});
  }

  List<String> convertStringToList(String input) {
    String cleanedInput = input.replaceAll(RegExp(r'[\[\]]'), '');
    List<String> result = cleanedInput.split(',').map((s) => s.trim()).toList();
    return result;
  }

  String removeTrailingComma(String input) {
    if (input.endsWith(',')) {
      return input.substring(0, input.length - 1).trim();
    }
    return input.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? SplashScreen() : widget.isAuthor ? AuthorDashboard(context) : ReaderDashboard(context),
    );
  }

  //ReaderDashboard
  Widget ReaderDashboard(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 50),
        SizedBox(
          height: screenHeight * .3,
          width: screenWidth * .7,
          child: Stack(
            children: [
              Center(
                child: Container(
                  height: screenHeight * .85,
                  width: screenWidth * .65,
                  child: Image.asset("assets/img_5.png"),
                ),
              ),
              Positioned(
                bottom: screenHeight * .14,
                left: screenWidth * .19,
                child: Text(
                  "Hello, ${widget.username}",
                  style: TextStyle(fontSize: 25,color: Colors.grey[600]),
                ),
              ),
              Positioned(
                bottom: 65,
                left: screenWidth * .3,
                child: Image.asset("assets/crown.png", width: 35, height: 35),
              ),
              Positioned(
                bottom: 150,
                left: screenWidth * .20,
                child: Image.asset("assets/hourse.png", width: 120, height: 120),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 3,
          child: ListView.separated(
            itemBuilder: itemBuilder1,
            separatorBuilder: (context, index) => const SizedBox(height: 18),
            itemCount: uniqueStoryNames.length,
          ),
        ),
      ],
    );
  }


  Widget itemBuilder1(BuildContext context, int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    animalUrl.clear();
    String q =  chars[index];
    q=removeTrailingComma(q);
    animalUrl=convertStringToList(q);
    String? s= authorNames[index];
    print(s);



    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: SizedBox(
        width: screenWidth * .85,
        child: Card(
          margin: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 40,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(6),
                child:SizedBox(
                  width: MediaQuery.of(context).size.width * .38,
                  height: MediaQuery.of(context).size.height * .26,
                  child: Stack(
                    children: [
                      Center(
                        // place
                        child: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(50),bottomLeft: Radius.circular(50)),
                            image: DecorationImage(
                              image: NetworkImage(places[index]),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      if (animalUrl.length>= 1)
                        Positioned(
                          bottom: -20,
                          left: 60,
                          child: Center(
                            child: Container(
                              width: 120,
                              height: 120,
                              child: animalUrl[0] != null
                                  ? Image.network(animalUrl[0]!, fit: BoxFit.cover)
                                  : CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      if (animalUrl.length >= 2)
                        Positioned(
                          bottom: -10,
                          left:-10,
                          child: Center(
                            child: Container(
                              width: 120,
                              height: 120,
                              child: animalUrl[1] != null
                                  ? Image.network(animalUrl[1]!, fit: BoxFit.cover)
                                  : CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      if (animalUrl.length>= 3)
                        Positioned(
                          bottom: -20,
                          left: 30,
                          child: Center(
                            child: Container(
                              width: 120,
                              height: 120,
                              child: animalUrl[2] != null
                                  ? Image.network(animalUrl[2]!, fit: BoxFit.cover)
                                  : CircularProgressIndicator(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: 120,
                      child: Text(
                        textAlign: TextAlign.center,
                        "${uniqueStoryNames[index]}",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize:20, color: Color(0xffB04BA2)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 13,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Text(s,style: TextStyle(fontSize: 18),),
                      const SizedBox(width: 30),
                      InkWell(
                        onTap: (){
                          setState(()  {
                            fav[index] = !fav[index];

                            sqfLite.setFavoriteStoryStatus(uniqueStoryNames[index],fav[index]);
                          });
                        },
                        child: fav[index] ? Image.asset("assets/afterfav.png",width: 30):Image.asset("assets/beforefav.png",width: 30),

                      )

                    ],
                  ),
                  const SizedBox(height: 40),

                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (builder)=>Display(storyName: uniqueStoryNames[index],userName: widget.username,isAuthor: widget.isAuthor,)));
                      },
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xffFFDB5C),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Show",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget AuthorDashboard(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight * .06),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            "Hello, ${widget.username}!",
            style: const TextStyle(fontSize: 40, color: Color(0xffB04BA2)),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            "Today's gonna be productive",
            style: TextStyle(fontSize: 28, color: Colors.grey),
          ),
        ),
        Container(
          height: screenHeight * .4,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: itemBuilder2,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemCount: uniqueStoryNames.length,
          ),
        )
      ],
    );
  }

  Widget itemBuilder2(BuildContext context, int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    animalUrl.clear();
    String q =  chars[index];
    q=removeTrailingComma(q);
    animalUrl=convertStringToList(q);

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: SizedBox(
        width: screenWidth * .85,
        child: Card(
          margin: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 40,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(2),
                child:SizedBox(
                  width: MediaQuery.of(context).size.width * .4,
                  height: MediaQuery.of(context).size.height * .28,
                  child: Stack(
                    children: [
                      Center(
                        // place
                        child: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(50),bottomLeft: Radius.circular(50)),
                            image: DecorationImage(

                              image: NetworkImage(places[index]),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      if (animalUrl.length>= 1)
                        Positioned(
                          bottom: -20,
                          left: 50,
                          child: Center(
                            child: Container(
                              width: 120,
                              height: 120,
                              child: animalUrl[0] != null
                                  ? Image.network(animalUrl[0]!, fit: BoxFit.cover)
                                  : CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      if (animalUrl.length >= 2)
                        Positioned(
                          bottom: -20,
                          left:-20,
                          child: Center(
                            child: Container(
                              width: 120,
                              height: 120,
                              child: animalUrl[1] != null
                                  ? Image.network(animalUrl[1]!, fit: BoxFit.cover)
                                  : CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      if (animalUrl.length>= 3)
                        Positioned(
                          bottom: -20,
                          left: 30,
                          child: Center(
                            child: Container(
                              width: 120,
                              height: 120,
                              child: animalUrl[2] != null
                                  ? Image.network(animalUrl[2]!, fit: BoxFit.cover)
                                  : CircularProgressIndicator(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: 150,
                      child: Text(
                        textAlign: TextAlign.center,
                        "${uniqueStoryNames[index]}",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize:20, color: Color(0xffB04BA2)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (builder)=>Display(storyName: uniqueStoryNames[index],isAuthor: true,userName: widget.username,)));
                      },
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xffFFDB5C),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Show",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }




}
