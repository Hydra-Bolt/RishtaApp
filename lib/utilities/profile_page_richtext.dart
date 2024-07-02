import 'package:flutter/material.dart';

class ProfileRichText extends StatelessWidget {
  const ProfileRichText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Muneeb\n',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: '20\n',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text:
                  '\nHello! I\'m Muneeb, a 20-year-old with a zest for life and a passion for meaningful connections. I\'m drawn to older women who carry themselves with confidence and have thick thighs—it\'s a combination that truly captivates me. I believe in making the most out of every day, whether it\'s through embarking on new adventures, savoring different cuisines, or simply enjoying the beauty of the world around us.\nIn my spare time, I love exploring new places, whether it\'s a hidden gem in the city or a serene spot in nature. I\'m a foodie at heart and enjoy discovering new flavors and culinary experiences. But more than anything, I value deep and thoughtful conversations that allow me to connect with others on a genuine level.\nAuthenticity and honesty are cornerstones of my approach to life and relationships. I\'m looking for a woman who knows what she wants, appreciates the finer things in life, and isn\'t afraid to be herself. If you\'re someone who enjoys a good laugh, cherishes meaningful moments, and is open to exploring life\'s possibilities together, let\'s connect. I\'m excited to meet someone special who shares my enthusiasm for life and can join me on this exciting journey.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
