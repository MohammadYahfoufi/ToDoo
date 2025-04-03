import 'package:flutter/material.dart';
import 'package:last/category.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IntroPage(),
    );
  }
}

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              OnboardingPage(
                title: 'Conquer Your Day',
                description:
                    'Feeling overwhelmed? Take control of your day with our powerful to-do list app!',
                imagePath: 'assets/todoo.png',
                onNext: () {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
              ),
              OnboardingPage(
                title: 'Engage Together',
                description: 'Share Ideas, Ask Questions, and Stay Engaged',
                imagePath: 'assets/discuss.png',
                onNext: () {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
              ),
              OnboardingPage(
                title: 'Unlock Achievements',
                description:
                    'Turn to-dos into triumphs: Track progress, unlock achievements, earn badges, and celebrate wins!',
                imagePath: 'assets/Achievement.png',
                isLastPage: true,
                onNext: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage()),
                  );
                },
              ),
            ],
          ),
          Positioned(
            bottom: 50.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => _buildDot(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      width: _currentPage == index ? 16.0 : 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final bool isLastPage;
  final VoidCallback onNext;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
    this.isLastPage = false,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue[200],
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 300,
            height: 300,
          ),
          SizedBox(height: 32.0),
          Text(
            title,
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 32.0),
          if (isLastPage)
            ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              ),
              child: Text('Get Started'),
            ),
          if (!isLastPage)
            OutlinedButton(
              onPressed: onNext,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              ),
              child: Text('Next'),
            ),
        ],
      ),
    );
  }
}
