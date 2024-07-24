import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daeut_app/provider/user_provider.dart';
import 'package:daeut_app/screens/join_screen.dart';
import 'package:daeut_app/screens/login_screen.dart';
import 'package:daeut_app/screens/home_screen.dart';
import 'package:daeut_app/screens/insert_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JWT 토큰 로그인',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/main',
      routes: {
        '/main': (context) => const MainScreen(),
        '/reservation/list': (context) => const ListScreen(),
        // Add other routes here if necessary
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('생활 속 편리함'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '깔끔한 생활 도우미 예약 서비스',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              if (userHasRoles(['ROLE_PARTNER', 'ROLE_USER']) &&
                  !userHasRole('ROLE_ADMIN'))
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReservationInsertScreen()),
                    );
                  },
                  child: const Text('글쓰기'),
                ),
              const SizedBox(height: 20),
              const ReservationCardGrid(),
              const SizedBox(height: 20),
              const SearchContainer(),
              const SizedBox(height: 20),
              const Pagination(),
            ],
          ),
        ),
      ),
    );
  }
}

bool userHasRole(String role) {
  // Check if the user has the specified role
  // This is a placeholder for actual role checking logic
  return true;
}

bool userHasRoles(List<String> roles) {
  // Check if the user has all the specified roles
  // This is a placeholder for actual role checking logic
  return true;
}

class ReservationInsertScreen extends StatelessWidget {
  const ReservationInsertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('글쓰기'),
      ),
      body: const Center(
        child: Text('글쓰기 페이지'),
      ),
    );
  }
}

class ReservationCardGrid extends StatelessWidget {
  const ReservationCardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Example service list with hardcoded data
    final serviceList = [
      {
        'serviceCategory': '청소',
        'serviceName': '집 청소 서비스',
        'userName': '홍길동',
        'serviceNo': 1,
        'fileNo': 1,
      },
      {
        'serviceCategory': '이사',
        'serviceName': '포장이사 서비스',
        'userName': '김철수',
        'serviceNo': 2,
        'fileNo': 2,
      },
      {
        'serviceCategory': '수리',
        'serviceName': '가전제품 수리',
        'userName': '이영희',
        'serviceNo': 3,
        'fileNo': 3,
      },
      // Add more hardcoded services here
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 365 / 245,
      ),
      itemCount: serviceList.length,
      itemBuilder: (context, index) {
        final service = serviceList[index];
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (serviceList.isEmpty)
                const Center(child: Text('조회된 게시글 정보가 없습니다.')),
              if (serviceList.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.grey[200],
                  child: Text(service['serviceCategory'] as String),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReservationReadScreen(
                              serviceNo: service['serviceNo'] as int)),
                    );
                  },
                  child: Image.network(
                    'https://via.placeholder.com/365x245.png?text=Image+${service['fileNo']}',
                    width: 365,
                    height: 245,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service['serviceName'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(service['userName'] as String),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder for ListScreen content
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation List'),
      ),
      body: const Center(
        child: Text('Reservation List Page'),
      ),
    );
  }
}

class ReservationReadScreen extends StatelessWidget {
  final int serviceNo;
  const ReservationReadScreen({super.key, required this.serviceNo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation Detail'),
      ),
      body: Center(
        child: Text('Reservation Detail for service $serviceNo'),
      ),
    );
  }
}

class SearchContainer extends StatelessWidget {
  const SearchContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: '검색어를 입력하세요',
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Implement search logic
          },
        ),
      ],
    );
  }
}

class Pagination extends StatelessWidget {
  const Pagination({super.key});

  @override
  Widget build(BuildContext context) {
    // Example pagination data
    final servicePage = {
      'first': 1,
      'prev': 1,
      'next': 2,
      'last': 5,
      'page': 1,
      'start': 1,
      'end': 5,
    };
    final option = {'keyword': ''};

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.first_page),
          onPressed: () {
            // Navigate to first page
          },
        ),
        IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () {
            // Navigate to previous page
          },
        ),
        // for (int i = servicePage['start']; i <= servicePage['end']; i++)
        //   Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 4.0),
        //     child: GestureDetector(
        //       onTap: () {
        //         // Navigate to specific page
        //       },
        //       child: Text(
        //         '$i',
        //         style: TextStyle(
        //           fontWeight: servicePage['page'] == i
        //               ? FontWeight.bold
        //               : FontWeight.normal,
        //           color: servicePage['page'] == i
        //               ? Colors.deepPurple
        //               : Colors.black,
        //         ),
        //       ),
        //     ),
        //   ),
        IconButton(
          icon: const Icon(Icons.navigate_next),
          onPressed: () {
            // Navigate to next page
          },
        ),
        IconButton(
          icon: const Icon(Icons.last_page),
          onPressed: () {
            // Navigate to last page
          },
        ),
      ],
    );
  }
}
