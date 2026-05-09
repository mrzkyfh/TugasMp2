import 'quiz_level_model.dart';

class QuizData {
  static List<QuizLevel> getLevels() {
    return [
      // Level 1 - Basic Introduction
      QuizLevel(
        id: 1,
        title: 'Perkenalan',
        description: 'Belajar sapaan dan perkenalan dasar',
        totalQuestions: 5,
        category: 'Dasar',
        isLocked: false, // First level is unlocked
        progress: 0.0,
        questions: [
          QuizQuestion(
            question: 'Terjemahkan: "Halo"',
            options: ['Hello', 'Goodbye', 'Please', 'Sorry'],
            correctAnswerIndex: 0,
            explanation: '"Hello" artinya "Halo"',
            difficulty: 'easy',
          ),
          QuizQuestion(
            question: 'Terjemahkan: "Selamat pagi"',
            options: ['Good night', 'Good afternoon', 'Good morning', 'Hello'],
            correctAnswerIndex: 2,
            explanation: '"Good morning" artinya "Selamat pagi"',
            difficulty: 'easy',
          ),
          QuizQuestion(
            question: 'Terjemahkan: "Terima kasih"',
            options: ['Please', 'Thank you', 'You\'re welcome', 'Excuse me'],
            correctAnswerIndex: 1,
            explanation: '"Thank you" artinya "Terima kasih"',
            difficulty: 'easy',
          ),
          QuizQuestion(
            question: 'Terjemahkan: "Tolong"',
            options: ['Thank you', 'Sorry', 'Please', 'Excuse me'],
            correctAnswerIndex: 2,
            explanation: '"Please" artinya "Tolong"',
            difficulty: 'easy',
          ),
          QuizQuestion(
            question: 'Terjemahkan: "Selamat tinggal"',
            options: ['Hello', 'Goodbye', 'Good morning', 'See you'],
            correctAnswerIndex: 1,
            explanation: '"Goodbye" artinya "Selamat tinggal"',
            difficulty: 'easy',
          ),
        ],
      ),
      
      // Level 2 - Numbers
      QuizLevel(
        id: 2,
        title: 'Angka 1-10',
        description: 'Belajar berhitung dari 1 sampai 10',
        totalQuestions: 5,
        category: 'Angka',
        isLocked: false, // Unlocked after completing level 1
        progress: 0.0,
        questions: [
          QuizQuestion(
            question: 'Terjemahkan: "Satu"',
            options: ['Two', 'Three', 'One', 'Four'],
            correctAnswerIndex: 2,
            explanation: '"One" artinya "Satu"',
            difficulty: 'easy',
          ),
          QuizQuestion(
            question: 'Terjemahkan: "Lima"',
            options: ['Four', 'Five', 'Six', 'Seven'],
            correctAnswerIndex: 1,
            explanation: '"Five" artinya "Lima"',
            difficulty: 'easy',
          ),
          QuizQuestion(
            question: 'Terjemahkan: "Delapan"',
            options: ['Seven', 'Eight', 'Nine', 'Ten'],
            correctAnswerIndex: 1,
            explanation: '"Eight" artinya "Delapan"',
            difficulty: 'medium',
          ),
          QuizQuestion(
            question: 'Terjemahkan: "Sepuluh"',
            options: ['Nine', 'Ten', 'Eleven', 'Twelve'],
            correctAnswerIndex: 1,
            explanation: '"Ten" artinya "Sepuluh"',
            difficulty: 'medium',
          ),
          QuizQuestion(
            question: 'Terjemahkan: "Tiga"',
            options: ['Three', 'Two', 'Four', 'Five'],
            correctAnswerIndex: 0,
            explanation: '"Three" artinya "Tiga"',
            difficulty: 'easy',
          ),
        ],
      ),
      
      // Level 3 - Family Members
      QuizLevel(
        id: 3,
        title: 'Keluarga',
        description: 'Belajar nama anggota keluarga',
        totalQuestions: 5,
        category: 'Keluarga',
        isLocked: true, // Locked until level 2 is completed
        progress: 0.0,
        questions: [
          QuizQuestion(
            question: 'Terjemahkan: "Ibu"',
            options: ['Sister', 'Mother', 'Daughter', 'Aunt'],
            correctAnswerIndex: 1,
            explanation: '"Mother" artinya "Ibu"',
            difficulty: 'easy',
          ),
          QuizQuestion(
            question: 'Terjemahkan: "Ayah"',
            options: ['Brother', 'Uncle', 'Father', 'Grandfather'],
            correctAnswerIndex: 2,
            explanation: '"Father" artinya "Ayah"',
            difficulty: 'easy',
          ),
          QuizQuestion(
            question: 'Terjemahkan: "Kakak/Adik laki-laki"',
            options: ['Cousin', 'Brother', 'Uncle', 'Nephew'],
            correctAnswerIndex: 1,
            explanation: '"Brother" artinya "Kakak/Adik laki-laki"',
            difficulty: 'medium',
          ),
          QuizQuestion(
            question: 'Terjemahkan: "Kakak/Adik perempuan"',
            options: ['Sister', 'Cousin', 'Aunt', 'Mother'],
            correctAnswerIndex: 0,
            explanation: '"Sister" artinya "Kakak/Adik perempuan"',
            difficulty: 'medium',
          ),
          QuizQuestion(
            question: 'Terjemahkan: "Nenek"',
            options: ['Mother', 'Aunt', 'Grandmother', 'Daughter'],
            correctAnswerIndex: 2,
            explanation: '"Grandmother" artinya "Nenek"',
            difficulty: 'hard',
          ),
        ],
      ),
      
      // Level 4 - Food and Drinks
      QuizLevel(
        id: 4,
        title: 'Makanan & Minuman',
        description: 'Belajar nama makanan dan minuman umum',
        totalQuestions: 5,
        category: 'Makanan',
        isLocked: true,
        progress: 0.0,
        questions: [
          QuizQuestion(
            question: 'Terjemahkan: "Air"',
            options: ['Milk', 'Juice', 'Water', 'Coffee'],
            correctAnswerIndex: 2,
            explanation: '"Water" artinya "Air"',
            difficulty: 'easy',
          ),
          QuizQuestion(
            question: 'Terjemahkan: "Roti"',
            options: ['Rice', 'Bread', 'Meat', 'Fish'],
            correctAnswerIndex: 1,
            explanation: '"Bread" artinya "Roti"',
            difficulty: 'easy',
          ),
          QuizQuestion(
            question: 'Terjemahkan: "Susu"',
            options: ['Cheese', 'Egg', 'Milk', 'Butter'],
            correctAnswerIndex: 2,
            explanation: '"Milk" artinya "Susu"',
            difficulty: 'medium',
          ),
          QuizQuestion(
            question: 'Terjemahkan: "Kopi"',
            options: ['Tea', 'Coffee', 'Juice', 'Water'],
            correctAnswerIndex: 1,
            explanation: '"Coffee" artinya "Kopi"',
            difficulty: 'medium',
          ),
          QuizQuestion(
            question: 'Terjemahkan: "Nasi"',
            options: ['Pasta', 'Bread', 'Rice', 'Pizza'],
            correctAnswerIndex: 2,
            explanation: '"Rice" artinya "Nasi"',
            difficulty: 'hard',
          ),
        ],
      ),
      
      // Level 5 - Colors
      QuizLevel(
        id: 5,
        title: 'Warna',
        description: 'Belajar warna dasar',
        totalQuestions: 5,
        category: 'Warna',
        isLocked: true,
        progress: 0.0,
        questions: [
          QuizQuestion(
            question: 'Terjemahkan: "Merah"',
            options: ['Blue', 'Green', 'Red', 'Yellow'],
            correctAnswerIndex: 2,
            explanation: '"Red" artinya "Merah"',
            difficulty: 'easy',
          ),
          QuizQuestion(
            question: 'Terjemahkan: "Biru"',
            options: ['Green', 'Blue', 'Black', 'White'],
            correctAnswerIndex: 1,
            explanation: '"Blue" artinya "Biru"',
            difficulty: 'easy',
          ),
          QuizQuestion(
            question: 'Terjemahkan: "Kuning"',
            options: ['Yellow', 'Orange', 'Pink', 'Purple'],
            correctAnswerIndex: 0,
            explanation: '"Yellow" artinya "Kuning"',
            difficulty: 'medium',
          ),
          QuizQuestion(
            question: 'Terjemahkan: "Hijau"',
            options: ['Red', 'Blue', 'Green', 'Black'],
            correctAnswerIndex: 2,
            explanation: '"Green" artinya "Hijau"',
            difficulty: 'medium',
          ),
          QuizQuestion(
            question: 'Terjemahkan: "Putih"',
            options: ['Black', 'White', 'Grey', 'Brown'],
            correctAnswerIndex: 1,
            explanation: '"White" artinya "Putih"',
            difficulty: 'hard',
          ),
        ],
      ),
    ];
  }
  
  static QuizProgress getProgress() {
    final levels = getLevels();
    final completedLevels = levels.where((level) => level.stars > 0).length;
    final totalStars = levels.fold(0, (sum, level) => sum + level.stars);
    final maxStars = levels.length * 3;
    final overallProgress = completedLevels / levels.length;
    
    return QuizProgress(
      currentLevel: completedLevels + 1,
      totalLevels: levels.length,
      totalStars: totalStars,
      maxStars: maxStars,
      overallProgress: overallProgress,
    );
  }
}
