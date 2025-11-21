import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_bottom_nav.dart';
import 'widgets/news_tab.dart';
import 'widgets/teaching_tab.dart';
import 'widgets/dictionary_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar personalizado
      appBar: const CustomAppBar(title: 'App Zoque'),

      // Body con imagen de bienvenida y las diferentes pestañas
      body: Column(
        children: [
          // Imagen de bienvenida (solo visible en la pestaña de Noticias)
          if (_selectedIndex == 0)
            SizedBox(
              width: double.infinity,
              height: 260, // Altura fija para la sección de bienvenida
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // SVG como fondo (cover)
                  SvgPicture.asset(
                    'assets/welcome_icon.svg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 260,
                    alignment: Alignment.center,
                  ),

                  // Texto "Bienvenido" en bottom-left
                  Positioned(
                    bottom: 90,
                    left: 20,
                    child: Text(
                      'Bienvenido',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Contenido de las pestañas
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: const [NewsTab(), TeachingTab(), DictionaryTab()],
            ),
          ),
        ],
      ),

      // Bottom Navigation personalizado
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
