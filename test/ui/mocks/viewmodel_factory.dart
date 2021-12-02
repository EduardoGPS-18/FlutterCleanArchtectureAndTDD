import 'package:app_curso_manguinho/ui/pages/pages.dart';

class ViewModelFactory {
  static SurveyResultViewModel makeSurveyResult() => SurveyResultViewModel(
        surveyId: 'Any id',
        question: 'Question',
        answers: [
          SurveyAnswerViewModel(
            image: 'Image 0',
            answer: 'Answer 0',
            isCurrentAnswer: true,
            percent: '100%',
          ),
          SurveyAnswerViewModel(
            answer: 'Answer 1',
            isCurrentAnswer: false,
            percent: '30%',
          ),
        ],
      );
  static List<SurveyViewModel> makeSurveys() => [
        SurveyViewModel(id: '1', question: 'Question 1', date: 'Date 1', didAnswer: true),
        SurveyViewModel(id: '2', question: 'Question 2', date: 'Date 2', didAnswer: false),
      ];
}
