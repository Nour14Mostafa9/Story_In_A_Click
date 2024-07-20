import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {

  List<String> books=[
    "assets/book.jpg",
    "assets/book2.jpg",
    "assets/book3.jpg"
  ];

  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height*.1,
          ),
          const Center(
            child: Text("EXPLORE",style: TextStyle(fontSize: 50,color: Color(0xffFFDB5C)),),
          ),
          SizedBox( height: MediaQuery.of(context).size.height*.1),
          SizedBox(
            width: 350,
            child: Stack(
              children:[
                AnimSearchBar(
                searchIconColor: Colors.white,
                color: const Color(0xffFFDB5C) ,
                onSubmitted: (value){

                },
                width: 400,
                textController: textController,
                onSuffixTap: () {
                  setState(() {
                    textController.clear();
                  });
                },
              ),
              ]
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: itemBuilder,
                separatorBuilder:(context,index) => const SizedBox(height: 50,),
                itemCount: 3),
          )
        ],
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
        ),
        elevation: 40,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width:  MediaQuery.of(context).size.width*.5,
                height: MediaQuery.of(context).size.height*.28,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image:AssetImage( books[index]),
                    ),
                  borderRadius: BorderRadius.circular(50)
                ),
              ),
            ),
            Column(
              children: [
                const Text("Story",style: TextStyle(fontSize: 40)),
                const SizedBox(height: 50,),
                const Text("data "),
                const SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: InkWell(
                    onTap: (){},
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration:const BoxDecoration(
                        color: Color(0xffFFDB5C),
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomLeft:  Radius.circular(20))
                      ),
                      child: const Center(child: Text("Read" , style: TextStyle(color: Colors.white,fontSize: 20),)),
                    ),
                  ),
                )


              ],
            )
          ],
        ),

      ),
    );
  }
}
