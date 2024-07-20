import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Sqflite {
  static Database? _db;

  Future<Database?> get dB async {
    _db ??= await initialDB();
    return _db;
  }

  initialDB() async {
    String databasePath = await getDatabasesPath();
    String databaseName = "images.db";
    String path = join(databasePath, databaseName);
    Database? myDb = await openDatabase(path,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return myDb;
  }

  deleteDB() async {
    String databasePath = await getDatabasesPath();
    String databaseName = "images.db";
    String path = join(databasePath, databaseName);
    await deleteDatabase(path);
    print("d");
  }

  final animalTable = "animal";
  final placeTable = "place";
  final animalName = "name";
  final place = "place";
  final time = "time";
  final url = "url";

  _onCreate(Database db, int version) async {
    Batch batch = db.batch();

    batch.execute('''
    CREATE TABLE "user"(
      "email" TEXT NOT NULL PRIMARY KEY,
      "username" TEXT NOT NULL,
      "nickname" TEXT NOT NULL,
      "password" TEXT NOT NULL,
      "age" INTEGER NOT NULL,
      "favoriteAnimal" TEXT NOT NULL,
      "userTybe" TEXT NOT NULL
    )
  ''');

    batch.execute('''
    CREATE TABLE "story"(
      "sceneId" INTEGER NOT NULL PRIMARY KEY,
      "place" TEXT NOT NULL,
      "chars" TEXT NOT NULL,
      "conversation" TEXT NOT NULL,
      "sceneScript" TEXT NOT NULL,
      "storyName" TEXT NOT NULL,
      "author" TEXT NOT NULL,
      "isFavorite" INTEGER DEFAULT 0
    )
  ''');

    batch.execute('''
    CREATE TABLE "$animalTable"(
      "$animalName" TEXT NOT NULL PRIMARY KEY,
      "$url" TEXT NOT NULL,
      "isFavorite" INTEGER DEFAULT 0
    )
  ''');

    batch.execute('''
    CREATE TABLE "$placeTable"(
      "$place" TEXT NOT NULL PRIMARY KEY,
      "$url" TEXT NOT NULL
    )
  ''');

    print("object");
    await batch.commit();
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
/*    await db.execute('''
      CREATE TABLE "new_table"(
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "title" TEXT NOT NULL,
        "description" TEXT NOT NULL
      )
  ''');

    await db.execute('''
    INSERT INTO "new_table" ("id","title","description")
    SELECT id,title,description FROM "note";
''');

    await db.execute('''
    DROP TABLE "new_table"
''');

    await db.execute('''
    ALTER TABLE "new_table" RENAME TO "note";
''');*/

    print("onUpgrade");

  }



  Future<List<Map<String, dynamic>>> readAnimalData() async {
    Database? myDb = await dB;

    List<Map<String, dynamic>> result = await myDb!.query(animalTable);

    return result;
  }

  Future<List<Map<String, dynamic>>> readPlaceData() async {
    Database? myDb = await dB;

    List<Map<String, dynamic>> result = await myDb!.query(placeTable);

    return result;
  }

  Future<String> getUrlByAnimalName(String animalName) async {
    Database? myDb = await dB;

    List<Map<String, dynamic>> result = await myDb!.query(
      animalTable,
      columns: [url],
      where: 'name = ?',
      whereArgs: [animalName],
    );

    return result.first[url];
  }

  Future<String?> getUrlByPlaceName(String placeName) async {
    Database? myDb = await dB;

    List<Map<String, dynamic>> result = await myDb!.query(
      placeTable,
      columns: [url],
      where: 'place = ?',
      whereArgs: [placeName],
    );

    if (result.isNotEmpty) {
      return result.first[url];
    } else {
      return null; // Return null if the animal name is not found
    }
  }

  Future<void> insertInitialPlaceData() async {
    Database? myDb = await dB;

    // Inserting the first row

    //forest
    await myDb!.insert(placeTable, {
      place: 'morning forest',
      url:
      'https://drive.google.com/uc?export=view&id=1sBSCO4oSYsjKqT2gb1BARY9s_rRtJRjw',
    });
    await myDb!.insert(placeTable, {
      place: 'night forest',
      url:
      'https://drive.google.com/uc?export=view&id=1xwhPPftSZaNalBveSPB-CkcIQQA4o5c3',
    });

    //zoo
    await myDb!.insert(placeTable, {
      place: 'morning zoo',
      url:
      'https://drive.google.com/uc?export=view&id=1-icQn3HF27r2RnVhvdIhRbBvHmvR_6NA',
    });
    await myDb!.insert(placeTable, {
      place: 'night zoo',
      url:
      'https://drive.google.com/uc?export=view&id=1Bnu8ijxq-gwD6CdT_iOUf1hqtTWBPwOj',
    });

    //farm

    //https://drive.google.com/file/d/1y7lfN9b_1Bhs0bdFMRiM-1FkGD8sWSxN/view?usp=sharing
    //zoo
    await myDb!.insert(placeTable, {
      place: 'morning farm',
      url:
      'https://drive.google.com/uc?export=view&id=1SEuyTQ9hjzU-7ch9n3pyviu1Zmi8I8EU',
    });
    await myDb!.insert(placeTable, {
      place: 'night farm',
      url:
      'https://drive.google.com/uc?export=view&id=1y7lfN9b_1Bhs0bdFMRiM-1FkGD8sWSxN',
    });


    await myDb!.insert(placeTable, {
      place: 'night snowland',
      url:
      'https://drive.google.com/uc?export=view&id=1HhG2SK5ERsycXUjakY3VtLgcs1kOL78M',
    });

    await myDb!.insert(placeTable, {
      place: 'morning underwater',
      url:
      'https://drive.google.com/uc?export=view&id=1fieibFBUlcSojJugJRNqAi0Wyar2CZ8_',
    });


    print(' places data inserted successfully!');

  }

  Future<void> insertInitialAnimalData() async {
    Database? myDb = await dB;

    // Inserting animal data with updated emotions
    //panda
    await myDb!.insert(animalTable, {
      animalName: 'joy panda',
      url:
      'https://drive.google.com/uc?export=view&id=1Pd3Qan8Dc9IEaimA_NPV_O6Ntg0UApLg',
    });
    await myDb!.insert(animalTable, {
      animalName: 'joy wolf',
      url:
      'https://drive.google.com/uc?export=view&id=1FP6eK5sUFpOXjqDgrRNikGDa9nzP73SB',
    });
    await myDb.insert(animalTable, {
      animalName: 'sadness wolf',
      url:
      'https://drive.google.com/uc?export=view&id=1c8C6o_1ZLJ1_BU-_e7ttiMQ2k1sHZeMj',
    });
    await myDb.insert(animalTable, {
      animalName: 'anger wolf',
      url:
      'https://drive.google.com/uc?export=view&id=1RcVv2NH50r2oaFBscujUc3GZT9sEFS_W',
    });
    await myDb.insert(animalTable, {
      animalName: 'fear wolf',
      url:
      'https://drive.google.com/uc?export=view&id=1nSkghQrZ1rtRnU9zfR6YO3yU413Xr5S8',
    });
    await myDb.insert(animalTable, {
      animalName: 'love wolf',
      url:
      'https://drive.google.com/uc?export=view&id=1gdQ1SynB23JpOLx8xKSJuVYB8rEO4xa_',
    });

    // lion
    await myDb.insert(animalTable, {
      animalName: 'joy lion',
      url:
      'https://drive.google.com/uc?export=view&id=19ar4ZAc7dyDz-FmaqJbpeh9benSKGZr0',
    });
    await myDb.insert(animalTable, {
      animalName: 'sadness lion',
      url:
      'https://drive.google.com/uc?export=view&id=1chjH_cKXImDlJUfQHrTpIZAzSteO-u8q',
    });
    await myDb.insert(animalTable, {
      animalName: 'anger lion',
      url:
      'https://drive.google.com/uc?export=view&id=1_aaF6ytX-fQ8oVCoWbpfnSGlnrwDfLrN',
    });
    await myDb.insert(animalTable, {
      animalName: 'fear lion',
      url:
      'https://drive.google.com/uc?export=view&id=1DCDm9UbMv8UraXXfIoFzYmOXU2Nw2_vW',
    });
    await myDb.insert(animalTable, {
      animalName: 'love lion',
      url:
      'https://drive.google.com/uc?export=view&id=19ar4ZAc7dyDz-FmaqJbpeh9benSKGZr0',
    });

    // tiger
    await myDb.insert(animalTable, {
      animalName: 'joy tiger',
      url:
      'https://drive.google.com/uc?export=view&id=1jHollLgArnzjmCkUM74BaJkuJsIQGpMo',
    });
    await myDb.insert(animalTable, {
      animalName: 'sadness tiger',
      url:
      'https://drive.google.com/uc?export=view&id=1EOTbOgR8q9xzkrPLaODG-Ojid1xsV_-T',
    });
    await myDb.insert(animalTable, {
      animalName: 'anger tiger',
      url:
      'https://drive.google.com/uc?export=view&id=1gVhtkys8Ak374cK65-6u8YqlmAcO7fuG',
    });
    await myDb.insert(animalTable, {
      animalName: 'fear tiger',
      url:
      'https://drive.google.com/uc?export=view&id=19FXkZxk8XHD-vIPUaisQT7mHuNLYwWCG',
    });

    // rabbit
    await myDb.insert(animalTable, {
      animalName: 'joy rabbit',
      url:
      'https://drive.google.com/uc?export=view&id=1rQcbgDpGiIi25G3mi6rXb8RQ5hhPb06r',
    });
    await myDb.insert(animalTable, {
      animalName: 'sadness rabbit',
      url:
      'https://drive.google.com/uc?export=view&id=1QKRUsjSw7Jx1ZgM9n5iIKhN_LQErF9UE',
    });
    await myDb.insert(animalTable, {
      animalName: 'anger rabbit',
      url:
      'https://drive.google.com/uc?export=view&id=1T1nNZt53y9IRZdZ2Idob3PfPkeYwKuFm',
    });
    await myDb.insert(animalTable, {
      animalName: 'fear rabbit',
      url:
      'https://drive.google.com/uc?export=view&id=1B1GkfwQ2R7C1j4L5tV4DvM2Qvz5kXfQa',
    });
    await myDb.insert(animalTable, {
      animalName: 'love rabbit',
      url:
      'https://drive.google.com/uc?export=view&id=1L-Y8Q9jOwvVrC6pXAOcZ2QtMEdUfBE5w',
    });






    //dog
    await myDb.insert(animalTable, {
      animalName: 'joy dog',
      url:
      'https://drive.google.com/uc?export=view&id=1T1gk0zwVtxtRxY8xsDXkRHlbQX8sRmLz', // Replace with the actual ID
    });
    await myDb.insert(animalTable, {
      animalName: 'anger dog',
      url:
      'https://drive.google.com/uc?export=view&id=1fcMq8U4kB_UyOdgWP17p0n7TrlOzD_k2', // Replace with the actual ID
    });
    await myDb.insert(animalTable, {
      animalName: 'sadness dog',
      url:
      'https://drive.google.com/uc?export=view&id=1C_IkSHm0J_RMzCxe1rnQJsenE4_XioU-', // Replace with the actual ID
    });


    //mouse
    await myDb.insert(animalTable, {
      animalName: 'sadness mouse',
      url:
      'https://drive.google.com/uc?export=view&id=1fdPGKOXzI__q12UC69VAkQ01ViUWG894', // Replace with the actual ID
    });

    //sheep
    await myDb.insert(animalTable, {
      animalName: 'fear sheep',
      url:
      'https://drive.google.com/uc?export=view&id=19qjODKnH9Mbeu-LIK2thJqPmHq93RoN6', // Replace with the actual ID
    });
    await myDb.insert(animalTable, {
      animalName: 'anger sheep',
      url:
      'https://drive.google.com/uc?export=view&id=1G2KYnw-YriLZF0sSVLG74w8kgnBO4BSc', // Replace with the actual ID
    });
    await myDb.insert(animalTable, {
      animalName: 'sadness sheep',
      url:
      'https://drive.google.com/uc?export=view&id=1xBBgitXQKPiFvxosV3eaIiH-_NQ_5EOK', // Replace with the actual ID
    });
    await myDb.insert(animalTable, {
      animalName: 'joy sheep',
      url:
      'https://drive.google.com/uc?export=view&id=1PODxAeOGZZJU9KFBRdKps5atN3K60VKA', // Replace with the actual ID
    });

    //donkey
    await myDb.insert(animalTable, {
      animalName: 'fear donkey',
      url:
      'https://drive.google.com/uc?export=view&id=1ST7gRuSnTpMuxDNVLeyOuCDXHIHm26SH', // Replace with the actual ID
    });
    await myDb.insert(animalTable, {
      animalName: 'joy donkey',
      url:
      'https://drive.google.com/uc?export=view&id=1EkuZMmSqlHQ_1UJwHTOWnRSUQBnIQdWq', // Replace with the actual ID
    });


    //Penguin-> fear , sad , joy
    await myDb.insert(animalTable, {
      animalName: 'fear penguin',
      url:
      'https://drive.google.com/uc?export=view&id=1O61ms6S0PDXipm9mKG7vH3jJF6Qh2C45', // Replace with the actual ID
    });
    await myDb.insert(animalTable, {
      animalName: 'joy penguin',
      url:
      'https://drive.google.com/uc?export=view&id=1A6p-1d6l9lk_QWnXOLxG75FN6EXxiTlF', // Replace with the actual ID
    });
    await myDb.insert(animalTable, {
      animalName: 'sadness penguin',
      url:
      'https://drive.google.com/uc?export=view&id=1LI4Ukf82DYyZ2JGmOTaYtgF5N0KWw6Vu', // Replace with the actual ID
    });

    //Bear -> fear , joy
    await myDb.insert(animalTable, {
      animalName: 'fear bear',
      url:
      'https://drive.google.com/uc?export=view&id=1CWk77TiClKN01ZX-4Im6hyZvHmcfMJnb', // Replace with the actual ID
    });
    await myDb.insert(animalTable, {
      animalName: 'joy bear',
      url:
      'https://drive.google.com/uc?export=view&id=1TTzCV8jsZTnFyGNp7KZGEvTnq5YaMOQA', // Replace with the actual ID
    });

    //Crab -> sadnees , joy
    await myDb.insert(animalTable, {
      animalName: 'joy crab',
      url:
      'https://drive.google.com/uc?export=view&id=1E4PgAGIp1QSuWyKGW0kK9mSNfUTbfbJN', // Replace with the actual ID
    });
    await myDb.insert(animalTable, {
      animalName: 'sadness crab',
      url:
      'https://drive.google.com/uc?export=view&id=13s43iW2DsyLTGCaDUL3MnxnWGDNaOnzJ', // Replace with the actual ID
    });

    //Fish -> sadness , joy
    await myDb.insert(animalTable, {
      animalName: 'joy fish',
      url:
      'https://drive.google.com/uc?export=view&id=1lTy9xU9_b3EDNIwSVfdnwXxHUyZpgTFH', // Replace with the actual ID
    });
    await myDb.insert(animalTable, {
      animalName: 'sadness fish',
      url:
      'https://drive.google.com/uc?export=view&id=1z4a3CHZqX6UML1UUmP5Gcm_X46p4NLSb', // Replace with the actual ID
    });

    //starFish -> fear , joy
    await myDb.insert(animalTable, {
      animalName: 'joy starfish',
      url:
      'https://drive.google.com/uc?export=view&id=1XYnKAIWYi-J15NTeBy2ppDWDo_UxnCwV', // Replace with the actual ID
    });





    print('Animals data inserted successfully!');

  }


  // signin and login

  Future<void> insertUserData({
    required String email,
    required String username,
    required String nickname,
    required String password,
    required int age,
    required String favoriteAnimal,
    required String userType,
  }) async {
    Database? myDb = await dB;

    await myDb!.insert('user', {
      'email': email,
      'username': username,
      'nickname': nickname,
      'password': password,
      'age': age,
      'favoriteAnimal': favoriteAnimal,
      'userTybe': userType,
    });

    print('User data inserted successfully!');
  }



  Future<bool> checkPasswordByEmail(String email, String password) async {
    Database? myDb = await dB;

    List<Map<String, dynamic>> result = await myDb!.query(
      'user',
      columns: ['password'],
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      String storedPassword = result.first['password'];
      return storedPassword == password;
    } else {
      return false;
    }
  }

  Future<String> getUserTypeByEmail(String email) async {
    Database? myDb = await dB;

    List<Map<String, dynamic>> result = await myDb!.query(
      'user',
      columns: ['userTybe'],
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return result.first['userTybe'] as String;
    } else {
      return '';
    }
  }


  Future<void> updateUserInfo({
    required String email,
    required String favoriteAnimal,
    required int age,
    required String nickname,
  }) async {
    Database? myDb = await dB;

    await myDb!.update(
      'user',
      {
        'favoriteAnimal': favoriteAnimal,
        'age': age,
        'nickname': nickname,
      },
      where: 'email = ?',
      whereArgs: [email],
    );

    print('User data updated successfully!');
  }

  Future<void> updateInfo({
    required String password,
    required String username,
  }) async {
    Database? myDb = await dB;

    await myDb!.update(
      'user',
      {
        'username': username,
        'password': password,
      },
      where: 'username = ?',
      whereArgs: [username],
    );

    print('User data updated successfully!');
  }


  Future<bool> checkUserExistence(String email) async {

      Database? myDb = await dB;

      List<Map<String, dynamic>> result = await myDb!.query(
        'user',
        columns: ['email'],
        where: 'email = ?',
        whereArgs: [email],
      );
      if (result.isNotEmpty) {
        return true;
      } else {
        return false;
      }



  }


  Future<void> insertSceneData({
    required String place,
    required String characters,
    required String conversation,
    required String storyName,
    required String author,
    required String sceneScript,
  }) async {
    try {
      Database? myDb = await dB;

      await myDb!.insert('story', {
        'place': place,
        'chars': characters,
        'conversation': conversation,
        'storyName': storyName,
        'author': author,
        'sceneScript': sceneScript,
      });

      print('Scene data inserted successfully!');
    } catch (e) {
      print('Error inserting scene data: $e');
    }
  }


  Future<List<Map<String, dynamic>>> getScenesByStoryName(String storyName) async {
    try {
      Database? myDb = await dB;

      List<Map<String, dynamic>> result = await myDb!.query(
        'story',
        where: 'storyName = ?',
        whereArgs: [storyName],
      );

      print('Scenes retrieved successfully!');
      return result;
    } catch (e) {
      print('Error retrieving scenes: $e');
      return [];
    }
  }

  Future<int> getSceneCountByStoryName(String storyName) async {
    try {
      Database? myDb = await dB;

      List<Map<String, dynamic>> result = await myDb!.query(
        'story',
        where: 'storyName = ?',
        whereArgs: [storyName],
      );

      int sceneCount = result.length;
      print('Number of scenes for story "$storyName": $sceneCount');
      return sceneCount;
    } catch (e) {
      print('Error retrieving scene count: $e');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getAllScenesByStoryName(String storyName) async {
    try {
      Database? myDb = await dB;

      List<Map<String, dynamic>> result = await myDb!.query(
        'story',
        where: 'storyName = ?',
        whereArgs: [storyName],
      );

      print('All scenes retrieved successfully for story "$storyName"');
      return result;
    } catch (e) {
      print('Error retrieving scenes for story "$storyName": $e');
      return [];
    }
  }

  Future<List<String>> getAllUniqueStoryNames() async {
    Database? myDb = await dB;

    List<Map<String, dynamic>> result = await myDb!.query(
      'story',
      columns: ['storyName'],
      distinct: true,
    );

    List<String> storyNames = result.map((row) => row['storyName'] as String).toList();

    return storyNames;
  }

  Future<List<String>> getAllUniqueStoryNamesAuthors() async {
    Database? myDb = await dB;

    List<Map<String, dynamic>> result = await myDb!.query(
      'story',
      columns: ['author'],
    );

    List<String> storyNames = result.map((row) => row['author'] as String).toList();

    return storyNames;
  }

  // Return null if the email is not found
  Future<String?> getUsernameByEmail(String email) async {
    Database? myDb = await dB;

    List<Map<String, dynamic>> result = await myDb!.query(
      'user',
      columns: ['username'],
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return result.first['username'] as String;
    } else {
      return null;
    }
  }

  Future<String?> getEmailByUsername(String username) async {
    Database? myDb = await dB;

    List<Map<String, dynamic>> result = await myDb!.query(
      'user',
      columns: ['email'],
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      return result.first['email'] as String?;
    } else {
      return null; // Return null if the email is not found
    }
  }

  Future<String?> getPasswordByUsername(String username) async {
    Database? myDb = await dB;

    List<Map<String, dynamic>> result = await myDb!.query(
      'user',
      columns: ['password'],
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      return result.first['password'] as String?;
    } else {
      return null;
    }
  }


  Future<List<String>> getStoryNamesByAuthor(String author) async {
    Database? myDb = await dB;

    List<Map<String, dynamic>> result = await myDb!.query(
      'story',
      columns: ['storyName'],
      where: 'author = ?',
      whereArgs: [author],
      distinct: true,
    );

    List<String> storyNames = result.map((row) => row['storyName'] as String).toList();

    return storyNames;
  }

  Future<List<String>> getFavoriteStoryNames() async {
    Database? myDb = await dB;

    List<Map<String, dynamic>> result = await myDb!.query(
      'story',
      columns: ['storyName'],
      where: 'isFavorite = ?',
      whereArgs: [1],
      distinct: true,
    );

    List<String> storyNames = result.map((row) => row['storyName'] as String).toList();

    return storyNames;
  }

  Future<List<bool>> getFavorite() async {
    Database? myDb = await dB;


    List<Map<String, dynamic>> result = await myDb!.query(
      'story',
      columns: ['isFavorite'],
    );

    List<bool> isFavoriteList = result.map((row) => row['isFavorite'] == 1).toList();

    return isFavoriteList;
  }


  Future<void> setFavoriteStoryStatus(String storyName, bool isFavorite) async {
    Database? myDb = await dB;

    await myDb!.update(
      'story',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'storyName = ?',
      whereArgs: [storyName],
    );
  }



  Future<String?> getPlaceByStoryNameLastScene(String storyName) async {
    Database? myDb = await dB;

    final List<Map<String, dynamic>> maps = await myDb!.query(
      'story',
      columns: ['place'],
      where: 'storyName = ?',
      whereArgs: [storyName],
      orderBy: 'sceneId DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return maps.first['place'] as String?;
    }
    return null;
  }

  Future<String?> getCharsOfFirstSceneByStoryName(String storyName) async {
    Database? myDb = await dB;

    final List<Map<String, dynamic>> maps = await myDb!.query(
      'story',
      columns: ['chars'],
      where: 'storyName = ?',
      whereArgs: [storyName],
      orderBy: 'sceneId ASC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return maps.first['chars'] as String?;
    }
    return null;
  }

  Future<String?> getPlaceOfFirstSceneByStoryName(String storyName) async {
    Database? myDb = await dB;

    final List<Map<String, dynamic>> maps = await myDb!.query(
      'story',
      columns: ['place'],
      where: 'storyName = ?',
      whereArgs: [storyName],
      orderBy: 'sceneId ASC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return maps.first['place'] as String?;
    }
    return null;
  }


}





