import 'package:flutter/material.dart';
import 'package:woodcounter_application/pages/select_image.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/stack.png',
              height: 300,
            ),
            const Text('WoodCounter',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold)),
            const Text('Możesz na nas liczyć',
                style: TextStyle(color: Colors.white, fontSize: 25)),
            const SizedBox(height: 100),
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SelectImage()),
                );
              },
              child: const Text('Zaczynajmy!',
                  style: TextStyle(color: Colors.green, fontSize: 40)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/polish.png',
                height: 40,
              ),
              label: 'Polski'),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/british.png',
                height: 40,
              ),
              label: 'English'),
        ],
        backgroundColor: Colors.green,
        elevation: 0,
      ),
    );
  }
}
