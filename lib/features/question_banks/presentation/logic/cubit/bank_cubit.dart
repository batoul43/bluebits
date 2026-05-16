import 'package:bloc/bloc.dart';
import 'package:bluebits_app/features/question_banks/data/models/question_model.dart';
import 'package:meta/meta.dart';

part 'bank_state.dart';

class BankCubit extends Cubit<BankState> {
  BankCubit() : super(BankInitial());
  void backTOYear() {
    emit(BankLoading());
    emit(BankYear()); // Replace '2023' with the actual selected year
  }

  void backTOsubject(String year, List subjects) {
    emit(BankLoading());
    emit(
      BankSubject(year, subjects),
    ); // Replace '2023' with the actual selected year
  }

  void displaySubjects(String year) {
    emit(BankLoading());
    // Replace with actual subjects for the selected year
    List subjects = ['Subject 1', 'Subject 2', 'Subject 3'];
    emit(BankSubject(year, subjects));
  }

  void displayQuestion(String year, String subject) {
    emit(BankLoading());
    // Replace with actual questions for the selected year and subject
    List<QuestionModel> questions = [
      QuestionModel(
        questionText: 'Question 1',
        options: ['Option 1', 'Option 2', 'Option 3'],
        correctAnswer: 'Option 1',
      ),
      QuestionModel(
        questionText: 'Question 2',
        options: ['Option 1', 'Option 2', 'Option 3'],
        correctAnswer: 'Option 2',
      ),
      QuestionModel(
        questionText: 'Question 3',
        options: ['Option 1', 'Option 2', 'Option 3'],
        correctAnswer: 'Option 3',
      ),
    ];
    emit(
      BankQuestion(
        selectedyear: year,
        selectedsubject: subject,
        questions: questions,
      ),
    );
  }
}
