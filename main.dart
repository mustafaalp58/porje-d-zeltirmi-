import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class UserInfo {
  String username;
  String email;

  UserInfo({required this.username, required this.email});
}

class Event {
  String name;
  String description;
  String time;

  Event(this.name, this.description, this.time);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegistrationScreen(),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? selectedCity;

  final List<String> cities = ["İstanbul", "Ankara", "İzmir"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('29 Ekim Kutlama Etkinlikleri'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Kullanıcı Adı'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'E-Posta'),
            ),
            DropdownButton<String>(
              value: selectedCity,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCity = newValue;
                });
              },
              items: cities.map((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                final username = usernameController.text;
                final email = emailController.text;
                final userInfo = UserInfo(username: username, email: email);

                if (selectedCity != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CityCulturePage(
                        currentUser: userInfo,
                        selectedCity: selectedCity!,
                      ),
                    ),
                  );
                }
              },
              child: Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}

class CityCulturePage extends StatelessWidget {
  final UserInfo currentUser;
  final String selectedCity;

  CityCulturePage({required this.currentUser, required this.selectedCity});

  @override
  Widget build(BuildContext context) {
    List<String> cultureCenters = [];

    if (selectedCity == "İstanbul") {
      cultureCenters = [
        "İstanbul Modern",
        "Sakıp Sabancı Müzesi",
        "Türkiye İş Bankası Kültür Yayınları Sanat Galerisi",
        "Koç Üniversitesi Anadolu Medeniyetleri Araştırma Merkezi (ANAMED)",
        "Cemal Reşit Rey Konser Salonu",
        "Zorlu Performans Sanatları Merkezi",
        "Borusan Sanat Galerisi",
        "Salt Galata",
        "Pera Müzesi",
      ];
    } else if (selectedCity == "İzmir") {
      cultureCenters = [
        "İzmir Büyükşehir Belediyesi Ahmed Adnan Saygun Sanat Merkezi",
        "Karşıyaka Belediyesi Atatürk Sanat Merkezi",
        "Bornova Belediyesi Kültür Merkezi",
        "Konak Belediyesi Şehit Fethi Bey Kültür Merkezi",
        "Buca Belediyesi Tınaztepe Kültür ve Sanat Merkezi",
        "Gaziemir Belediyesi Gaziemir Kültür Merkezi",
        "Menemen Belediyesi Kent Kültür Merkezi",
        "Bayraklı Belediyesi Hasan Akar Spor ve Kültür Merkezi",
        "Urla Belediyesi Atatürk Kültür Merkezi",
        "Aliağa Belediyesi Kültür Merkezi",
      ];
    } else if (selectedCity == "Ankara") {
      cultureCenters = [
        "Ankara Büyükşehir Belediyesi Nazım Hikmet Kültürevi",
        "Çankaya Belediyesi Çağdaş Sanatlar Merkezi (ÇAĞSAV)",
        "Keçiören Belediyesi Uğur Mumcu Kültür Merkezi",
        "Yenimahalle Belediyesi Nazım Hikmet Kültürevi",
        "Gölbaşı Belediyesi Göksu Kültür ve Sanat Merkezi",
        "Etimesgut Belediyesi Nazım Hikmet Kültürevi",
        "Sincan Belediyesi Ahmet Taner Kışlalı Kültür Merkezi",
        "Mamak Belediyesi Kültür Merkezi",
        "Altındağ Belediyesi Kültür ve Sanat Merkezi",
        "Akyurt Belediyesi Kültür Merkezi",
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('$selectedCity Kültür Merkezleri'),
      ),
      body: ListView.separated(
        itemCount: cultureCenters.length,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cultureCenters[index]),
            leading: Icon(Icons.calendar_today),
            onTap: () {
              final events = getEventsForCultureCenter(
                  cultureCenters[index]); // Kültür merkezi için etkinlikleri al

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CultureCenterPage(
                    currentUser: currentUser,
                    selectedCity: selectedCity,
                    cultureCenterName: cultureCenters[index],
                    events: events,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CultureCenterPage extends StatelessWidget {
  final UserInfo currentUser;
  final String selectedCity;
  final String cultureCenterName;
  final List<Event> events;

  CultureCenterPage({
    required this.currentUser,
    required this.selectedCity,
    required this.cultureCenterName,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$cultureCenterName Etkinlikleri'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(events[index].name),
            subtitle: Text(events[index].description),
            trailing: Text(events[index].time),
          );
        },
      ),
    );
  }
}

List<Event> getEventsForCultureCenter(String cultureCenterName) {
  if (cultureCenterName == "İstanbul Modern") {
    return [
      Event("Resim Sergisi", "Cumhuriyet temalı resim sergisi", "Saat: 10:00"),
      Event("Müzik Konseri", "Cumhuriyet temalı müzik konseri", "Saat: 19:00"),
      Event("Edebiyat Okuması", "Yerel yazarların kitaplarını okuma etkinliği",
          "Saat: 15:00"),
      // İstanbul Modern için diğer etkinlikleri buraya ekleyebilirsiniz.
    ];
  }
  // Diğer kültür merkezleri için benzer bir yapı kullanabilirsiniz.

  return [];
}
