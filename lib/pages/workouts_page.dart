import 'package:flutter/material.dart';
import '../services/exercise_api_service.dart';

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  List<String> targetList = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTargetList();
  }

  Future<void> _loadTargetList() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final targets = await ExerciseApiService.getTargetList();
      setState(() {
        targetList = targets;
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
            onPressed: _loadTargetList,
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
                        onPressed: _loadTargetList,
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
                        '운동 부위 선택',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '운동하고 싶은 부위를 선택하세요:',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: targetList.length,
                        itemBuilder: (context, index) {
                          final target = targetList[index];
                          return Card(
                            elevation: 4,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExercisesByTargetPage(target: target),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _getTargetIcon(target),
                                      size: 32,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      target,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }

  IconData _getTargetIcon(String target) {
    switch (target.toLowerCase()) {
      case 'back':
        return Icons.accessibility_new;
      case 'cardio':
        return Icons.favorite;
      case 'chest':
        return Icons.fitness_center;
      case 'lower arms':
        return Icons.pan_tool;
      case 'lower legs':
        return Icons.directions_run;
      case 'neck':
        return Icons.headset;
      case 'shoulders':
        return Icons.accessibility;
      case 'upper arms':
        return Icons.sports_martial_arts;
      case 'upper legs':
        return Icons.directions_walk;
      case 'waist':
        return Icons.accessibility_new;
      default:
        return Icons.fitness_center;
    }
  }
}

class ExercisesByTargetPage extends StatefulWidget {
  final String target;

  const ExercisesByTargetPage({super.key, required this.target});

  @override
  State<ExercisesByTargetPage> createState() => _ExercisesByTargetPageState();
}

class _ExercisesByTargetPageState extends State<ExercisesByTargetPage> {
  List<dynamic> exercises = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final exerciseList = await ExerciseApiService.getExercisesByTarget(widget.target);
      setState(() {
        exercises = exerciseList;
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
        title: Text('${widget.target} 운동'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadExercises,
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
                        onPressed: _loadExercises,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : exercises.isEmpty
                  ? const Center(
                      child: Text(
                        '이 부위에 대한 운동이 없습니다.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = exercises[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              exercise['name'] ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text('부위: ${exercise['target'] ?? 'Unknown'}'),
                                Text('장비: ${exercise['equipment'] ?? 'Unknown'}'),
                                if (exercise['gifUrl'] != null)
                                  const Text('GIF 이미지 있음'),
                              ],
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExerciseDetailPage(
                                    exerciseId: exercise['id'].toString(),
                                    exerciseName: exercise['name'] ?? 'Unknown',
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}

class ExerciseDetailPage extends StatefulWidget {
  final String exerciseId;
  final String exerciseName;

  const ExerciseDetailPage({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
  });

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  Map<String, dynamic>? exerciseDetail;
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadExerciseDetail();
  }

  Future<void> _loadExerciseDetail() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final detail = await ExerciseApiService.getExerciseById(widget.exerciseId);
      setState(() {
        exerciseDetail = detail;
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
        title: Text(widget.exerciseName),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadExerciseDetail,
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
                        onPressed: _loadExerciseDetail,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : exerciseDetail == null
                  ? const Center(
                      child: Text(
                        '운동 정보를 불러올 수 없습니다.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (exerciseDetail!['gifUrl'] != null)
                            Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  exerciseDetail!['gifUrl'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(
                                        Icons.error,
                                        size: 50,
                                        color: Colors.red,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          const SizedBox(height: 24),
                          _buildInfoCard('운동명', exerciseDetail!['name'] ?? 'Unknown'),
                          const SizedBox(height: 16),
                          _buildInfoCard('부위', exerciseDetail!['target'] ?? 'Unknown'),
                          const SizedBox(height: 16),
                          _buildInfoCard('장비', exerciseDetail!['equipment'] ?? 'Unknown'),
                          const SizedBox(height: 16),
                          _buildInfoCard('운동 ID', exerciseDetail!['id']?.toString() ?? 'Unknown'),
                          if (exerciseDetail!['bodyPart'] != null) ...[
                            const SizedBox(height: 16),
                            _buildInfoCard('신체 부위', exerciseDetail!['bodyPart']),
                          ],
                        ],
                      ),
                    ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
