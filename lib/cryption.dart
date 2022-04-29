class Cryption {
  static BigInt d = BigInt.parse('206322540520532197943279619');
  static BigInt n = BigInt.parse('309483810781924471631511553');

          //Diffie–Hellman key exchange realisation part\\
  //core function of encryption:
  //algorithm of modular exponentiation
  //should be used here, but exponentiation result
  //always lower then (BigInt) n, so I just remove it
  //and make simple power function
  static BigInt bigPow(BigInt num) {
    int e = 3;
    BigInt result = BigInt.one;
    for (int i = 0; i < e; i++) {
      result *= num;
    }
    return result;
  }
  //core function of decryption:
  //algorithm of modular exponentiation is used here
  static BigInt calcMod(BigInt num, BigInt d, BigInt n) {
    BigInt result = BigInt.one;
    while(d != BigInt.zero) {
      if ((d & BigInt.one) != BigInt.zero) {
        result *= num;
        result %= n;
      }
      num *= (num % n);
      num %= n;
      d >>= 1;
    }
    return result;
  }
          //end\\

          //suit this realisation to UI\\
  static String encryptionText(String text) {
    List<BigInt> textList = List.empty(growable: true);
    //create List<BigInt> of ascii from input text
    //example: abc => [97, 98, 99]
    textList = [for (var i = 0; i < text.length; i++) {
      BigInt.parse(text.codeUnitAt(i).toString()) }];

    //make obfuscation of code:
    //the main goal of obfuscation is
    //make harder simple guessing a message
    for (int i = 1; i < textList.length; i++) {
      textList[i] = (textList[i] + textList[i - 1]);
    }
    //call core function on each letter
    for (int i = 0; i < textList.length; i++) {
      textList[i] = bigPow(textList[i]);
    }


    //make List to string, as ('97, 98, 99')
    text = textList.join(",");
    return text;
  }

  static String decryptionText(String text) {
    try {
      if (text.isEmpty) {
        return '';
      }
      //create List<string> of ascii from input enumeration
      //example: ('97, 98, 99') => ['97', '98', '99']
      List textListStr = text.split(',');
      //List<string> to List<BigInt>
      List<BigInt> textListBigInt = textListStr.map((e) => BigInt.parse(e)).cast<BigInt>().toList();
      List<int> textListInt = List.filled(textListBigInt.length, 0);

      //call core function on each letter
      for (int i = 0; i < textListInt.length; i++) {
        //I sure, result suit integer, and I don't lose data
        textListInt[i] = calcMod(textListBigInt[i], d, n).toInt();
      }
      //make deobfuscation
      for (int i = textListInt.length - 1; i > 0; i--) {
        textListInt[i] = (textListInt[i] - textListInt[i - 1]);
      }

      //make List<int> to string via fromCharCodes
      text = String.fromCharCodes(textListInt);
      return text;
    } on Exception {
      return 'please write valid code';
    }
  }
          //end\\
}