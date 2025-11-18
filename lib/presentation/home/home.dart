import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      // AppBar con imagen
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/top_image.jpg'), // Cambia por tu imagen
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          'App Zoque',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      // Body con ListView de cards
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Noticias
          ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: 5, // Cambia por el número de noticias/cuentos
            itemBuilder: (context, index) {
              return _buildNewsCard(context, index);
            },
          ),
          // Enseñanza
          Center(child: Text('Contenido de Enseñanza')),
          // Diccionario
          Center(child: Text('Contenido de Diccionario')),
        ],
      ),
      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Noticias'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Enseñanza'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Diccionario',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,

        onTap: _onItemTapped,
      ),
    );
  }

  // Widget para construir cada card de noticia o cuento
  Widget _buildNewsCard(BuildContext context, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de la noticia (opcional)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/news_image_$index.jpg', // Cambia por tu imagen
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 12),
            // Título en español
            Text(
              'Título de la noticia o cuento $index',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            // Título en lengua zoque
            Text(
              'Shük tsoon xöö kax ta jna $index', // Ejemplo en Zoque
              style: GoogleFonts.notoSans(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 8),
            // Descripción
            Text(
              'Esta es una breve descripción de la noticia o cuento...',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
