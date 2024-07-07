import 'package:flutter/material.dart';

class MyChatBoxCard extends StatelessWidget {
  const MyChatBoxCard({
    super.key,
    this.cardImage = 'assets/icons/Profile.png',
    this.cardName = 'John Doe',
    this.cardDescription =
        'Adjust the parameters and styles as needed to fit your design requirements. Adjust the parameters and styles as needed to fit',
  });

  final String cardImage;
  final String cardName;
  final String cardDescription;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: const Color.fromARGB(255, 252, 202, 197),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      child: Row(
        children: [
          CircleAvatar(
            // backgroundColor: Colors.transparent,
            radius: 34,
            child: Image.asset(
              cardImage,
              fit: BoxFit.fill,
              repeat: ImageRepeat.noRepeat,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.11,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    cardName,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    cardDescription,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// Text Overflow problem in the decription is solved.