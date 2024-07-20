import 'package:first/Display.dart';
import 'package:first/SqfLiteHelper/Sqflite.dart';
import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  final bool isAuthor;
  final String username;

  const Favorites({super.key, required this.isAuthor, required this.username});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  Sqflite sqfLite = Sqflite();
  List<String> uniqueStoryNames = [];
  List<String> chars = [];
  List<String> authorNames = [];
  List<String> places = [];

  Future<void> fetchUniqueStoryNames() async {
    uniqueStoryNames = await sqfLite.getFavoriteStoryNames();
    authorNames = await sqfLite.getAllUniqueStoryNamesAuthors();
    await getChars();
  }

  Future<void> getChars() async {
    for (var s in uniqueStoryNames) {
      String? charsOfEachScene = await sqfLite.getCharsOfFirstSceneByStoryName(s);
      String? pp = await sqfLite.getPlaceOfFirstSceneByStoryName(s);
      pp = await sqfLite.getUrlByPlaceName(pp!);

      places.add(pp!);

      List<String> q = convertStringToList(charsOfEachScene!);
      String r = '';
      for (var s in q) {
        String w = await sqfLite.getUrlByAnimalName(s);
        r = r + w + ',';
      }
      chars.add(r);
    }
  }

  String removeTrailingComma(String input) {
    if (input.endsWith(',')) {
      return input.substring(0, input.length - 1).trim();
    }
    return input.trim();
  }

  List<String> convertStringToList(String input) {
    String cleanedInput = input.replaceAll(RegExp(r'[\[\]]'), '');
    List<String> result = cleanedInput.split(',').map((s) => s.trim()).toList();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchUniqueStoryNames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return buildContent(context);
          }
        },
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .1,
        ),
        const Center(
          child: Text("FAVORITES", style: TextStyle(fontSize: 50, color: Color(0xffCFADAD))),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .03),
        Image.asset("assets/img_4.png", width: 200, height: 200),
        SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            itemCount: uniqueStoryNames.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: itemBuilder1,
          ),
        ),
      ],
    );
  }

  Widget itemBuilder1(BuildContext context, int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    String q = chars[index];
    q = removeTrailingComma(q);
    List<String> animalUrl = convertStringToList(q);

    return SizedBox(
      width: screenWidth * .85,
      height: MediaQuery.of(context).size.height * .3,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Display(
                storyName: uniqueStoryNames[index],
                userName: widget.username,
                isAuthor: widget.isAuthor,
              ),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 40,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .44,
                height: MediaQuery.of(context).size.height * .20,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                          image: DecorationImage(
                            image: NetworkImage(places[index]),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    if (animalUrl.isNotEmpty)
                      Positioned(
                        bottom: -20,
                        left: 80,
                        child: Center(
                          child: Container(
                            width: 80,
                            height: 120,
                            child: Image.network(animalUrl[0], fit: BoxFit.fill),
                          ),
                        ),
                      ),
                    if (animalUrl.length >= 2)
                      Positioned(
                        bottom: -10,
                        left: -10,
                        child: Center(
                          child: Container(
                            width: 120,
                            height: 120,
                            child: Image.network(animalUrl[1], fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    if (animalUrl.length >= 3)
                      Positioned(
                        bottom: -20,
                        left: 30,
                        child: Center(
                          child: Container(
                            width: 120,
                            height: 120,
                            child: Image.network(animalUrl[2], fit: BoxFit.cover),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  width: 120,
                  child: Text(
                    textAlign: TextAlign.center,
                    uniqueStoryNames[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 18, color: Color(0xffB04BA2)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
