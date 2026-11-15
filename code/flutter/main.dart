// 路径：lib/main.dart
// 运行：flutter create student_demo && 用本文件替换 lib/main.dart && flutter run
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class Student {
  final String id;
  final String name;
  final String major;
  const Student(this.id, this.name, this.major);
}

const List<Student> kStudents = [
  Student('2023010101', '李思远', '软件工程'),
  Student('2023010102', '王雨桐', '软件工程'),
  Student('2023020104', '李梦琪', '数据科学与大数据技术'),
  Student('2023030107', '李欣然', '人工智能'),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '学生列表',
      theme: ThemeData(colorSchemeSeed: const Color(0xFF4E6EF2), useMaterial3: true),
      home: const StudentListPage(),
    );
  }
}

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final TextEditingController _controller = TextEditingController();
  String _keyword = '';
  bool _loading = true;
  List<Student> _students = const [];

  @override
  void initState() {
    super.initState();
    // Future + 延迟模拟网络：先 loading，600ms 后落数据
    Future<void>.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _students = kStudents;
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Student> get _filtered {
    final String k = _keyword.trim();
    return k.isEmpty ? _students : _students.where((Student s) => s.name.contains(k)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('学生列表')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: '输入姓名搜索，如：李',
                border: OutlineInputBorder(),
              ),
              onChanged: (String v) => setState(() => _keyword = v),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '共 ${_students.length} 名 · 命中 ${_filtered.length} 名',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text('数据加载中…', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    if (_filtered.isEmpty) {
      return const Center(child: Text('没有匹配的学生，换个关键字试试', style: TextStyle(color: Colors.grey)));
    }
    return ListView.separated(
      itemCount: _filtered.length,
      separatorBuilder: (BuildContext context, int i) => const SizedBox(height: 8),
      itemBuilder: (BuildContext context, int i) {
        final Student s = _filtered[i];
        return ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF4E6EF2),
            child: Text(s.name.substring(0, 1), style: const TextStyle(color: Colors.white)),
          ),
          title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${s.major} · 学号 ${s.id}'),
          trailing: const Icon(Icons.chevron_right),
          // 路由：Navigator.push 入栈，把 id 作为构造参数传给详情页
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (BuildContext ctx) => StudentDetailPage(id: s.id)),
          ),
        );
      },
    );
  }
}

class StudentDetailPage extends StatelessWidget {
  final String id;
  const StudentDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final Student? s = kStudents.cast<Student?>().firstWhere(
          (Student? x) => x != null && x.id == id,
          orElse: () => null,
        );
    return Scaffold(
      appBar: AppBar(title: const Text('学生详情')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(10)),
              child: Text('路由参数 id = $id', style: const TextStyle(color: Color(0xFF4E6EF2), fontSize: 12)),
            ),
            const SizedBox(height: 12),
            if (s == null)
              const Text('没有找到 id 对应的学生', style: TextStyle(color: Colors.grey))
            else ...<Widget>[
              Text(s.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('${s.major} · 学号 ${s.id}', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              // 出栈返回，对应 uni.navigateBack
              FilledButton(onPressed: () => Navigator.pop(context), child: const Text('返回列表')),
            ],
          ],
        ),
      ),
    );
  }
}
