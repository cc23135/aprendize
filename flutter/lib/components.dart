import 'package:aprendize/colors.dart';
import 'package:flutter/material.dart';

class CardColecao extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  const CardColecao({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.white, width: 2), 
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF8C52FF).withOpacity(0.8), const Color(0xFF5E17EB).withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            // Content on top of image and gradient
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      shadows: [
                        Shadow(
                          color: Color(0x80000000), // 50% opacity black
                          blurRadius: 4.45,
                          offset: Offset(0, 2), // Ajuste a posição da sombra conforme necessário
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40), 
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      shadows: [
                        Shadow(
                          color: Color(0x80000000), // 50% opacity black
                          blurRadius: 4.45,
                          offset: Offset(0, 2), // Ajuste a posição da sombra conforme necessário
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
