import 'package:flutter/material.dart';

import '../mainScreens/home_screen.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange.shade300, Colors.pink,],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.2, 0.9],
            ),
          ),
        ),
        title: const Text(
          'About Us',
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 0.5,
          fontSize: 24.0,
        ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          },
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Street Vendors App',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.0,),

            Text(
              'Developing a mobile application in Flutter that enable users to easily locate and access information about nearby street vendors.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),

            SizedBox(height: 18.0,),

            Text(
              'Our Mission:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),

            SizedBox(height: 4.0),

            Text(
              'To enable users to easily locate and access information about street vendors, display the opening and closing time of street vendors and enable users to view the average pricing of street vendors online.',
              style: TextStyle(fontSize: 16.0),
            ),

            SizedBox(height: 18.0),

            Text(
              'Our Team:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),

            SizedBox(height: 8.0),

            TeamMemberCard(
              name: 'Manish Badole',
              role: 'Developer',
              imageUrl: 'images/manishPhoto.jpg',
            ),

            // TeamMemberCard(
            //   name: 'Jane Smith',
            //   role: 'CTO',
            //   imageUrl: 'assets/images/jane_smith.jpg',
            // ),
            // Add more team member cards as needed

            SizedBox(height: 16.0),

            Text(
              'Contact Us:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),

            SizedBox(height: 8.0),

            Text(
              'Email: badolemanish419@gmail.com\nPhone: +917879076448',
              style: TextStyle(fontSize: 16.0),
            ),


            SizedBox(height: 22.0,),

            Text(
              'If you like it, Please rate us on PlayStore!!',
              style: TextStyle(
                color: Colors.green,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 40.0,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'THANK YOU  ❤',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 24.0,
                    letterSpacing: 2.0,
                  ),
                  textAlign: TextAlign.center,
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TeamMemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String imageUrl;

  const TeamMemberCard({super.key,
    required this.name,
    required this.role,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 50.0,
          backgroundImage: AssetImage(imageUrl),
        ),
        title: Text(
          name,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        ),
        subtitle: Text(
            role,
          style: const TextStyle(
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }
}
