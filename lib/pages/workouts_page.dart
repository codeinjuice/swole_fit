import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../services/exercise_api_service.dart';

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  List<String> bodyPartList = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBodyPartList();
  }

  Future<void> _loadBodyPartList() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final bodyParts = await ExerciseApiService.getBodyPartList();
      setState(() {
        bodyPartList = bodyParts;
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
            onPressed: _loadBodyPartList,
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
                        onPressed: _loadBodyPartList,
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
                        '신체 부위 선택',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '운동하고 싶은 신체 부위를 선택하세요:',
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
                        itemCount: bodyPartList.length,
                        itemBuilder: (context, index) {
                          final bodyPart = bodyPartList[index];
                          return Card(
                            elevation: 4,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExercisesByBodyPartPage(bodyPart: bodyPart),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _getBodyPartIcon(bodyPart),
                                      size: 32,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      bodyPart,
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

  IconData _getBodyPartIcon(String bodyPart) {
    switch (bodyPart.toLowerCase()) {
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

class ExercisesByBodyPartPage extends StatefulWidget {
  final String bodyPart;

  const ExercisesByBodyPartPage({super.key, required this.bodyPart});

  @override
  State<ExercisesByBodyPartPage> createState() => _ExercisesByBodyPartPageState();
}

class _ExercisesByBodyPartPageState extends State<ExercisesByBodyPartPage> {
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
      final exerciseList = await ExerciseApiService.getExercisesByBodyPart(widget.bodyPart);
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
        title: Text('${widget.bodyPart} 운동'),
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
  Uint8List? exerciseImageBytes;
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
      // 운동 상세 정보와 이미지를 동시에 로드
      final results = await Future.wait([
        ExerciseApiService.getExerciseById(widget.exerciseId),
        ExerciseApiService.getExerciseImage(widget.exerciseId),
      ]);

      setState(() {
        exerciseDetail = results[0] as Map<String, dynamic>;
        exerciseImageBytes = results[1] as Uint8List;
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Content Section
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Exercise Name Header
                                Text(
                                  exerciseDetail!['name'] ?? 'Unknown',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                
                                // Target muscle chip
                                if (exerciseDetail!['target'] != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      exerciseDetail!['target'],
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                
                                const SizedBox(height: 24),
                                
                                // GIF Section (if available)
                                if (exerciseDetail!['gifUrl'] != null) ...[
                                  Container(
                                    width: double.infinity,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        exerciseDetail!['gifUrl'],
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: const Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.error,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    'GIF 로딩 실패',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 36),
                                ],
                                
                                // Exercise Details Grid
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '운동 정보',
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      _buildDetailRow('장비', exerciseDetail!['equipment'] ?? 'Unknown'),
                                      if (exerciseDetail!['bodyPart'] != null) ...[
                                        const SizedBox(height: 12),
                                        _buildDetailRow('신체 부위', exerciseDetail!['bodyPart']),
                                      ],
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(height: 24),
                                
                                // Exercise Image Section (at the bottom)
                                if (exerciseImageBytes != null)
                                  Container(
                                    width: double.infinity,
                                    height: 270,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.memory(
                                        exerciseImageBytes!,
                                        fit: BoxFit.contain,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                                
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
