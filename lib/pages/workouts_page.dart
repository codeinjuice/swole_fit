import 'package:flutter/material.dart';
import '../services/exercise_api_service.dart';

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  List<dynamic> exercises = [];
  List<String> targetList = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // 모든 운동 목록과 부위 목록을 동시에 로드
      final results = await Future.wait([
        ExerciseApiService.getAllExercises(),
        ExerciseApiService.getTargetList(),
      ]);

      setState(() {
        exercises = results[0] as List<dynamic>;
        targetList = results[1] as List<String>;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: $errorMessage',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '운동 부위 목록 (${targetList.length}개)',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: targetList.map((target) => Chip(
                          label: Text(target),
                        )).toList(),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '운동 목록 (${exercises.length}개)',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: exercises.length > 10 ? 10 : exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = exercises[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(exercise['name'] ?? 'Unknown'),
                              subtitle: Text(exercise['target'] ?? 'Unknown target'),
                              trailing: Text(exercise['equipment'] ?? 'Unknown equipment'),
                            ),
                          );
                        },
                      ),
                      if (exercises.length > 10)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            '... and ${exercises.length - 10} more exercises',
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}
