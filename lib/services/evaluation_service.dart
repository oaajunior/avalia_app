import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/verify_internet_connection.dart';
import '../model/evaluation/evaluation_model.dart';
import '../model/question/question_model.dart';
import '../model/exceptions/internet_exception.dart';

abstract class EvaluationService {
  Future<dynamic> getEvaluation(String code);
}

class EvaluationServiceImpl implements EvaluationService {
  final _storeInstance = Firestore.instance;
  int totalQuestions = 0;
  int totalTimeQuestions = 0;

  @override
  Future<EvaluationModel> getEvaluation(String code) async {
    try {
      final isInternetOn = await VerifyInternetConnection.getStatus();
      if (!isInternetOn) {
        throw InternetException(
            'Não há conexão ativa com a internet. Por favor, verifique a sua conexão.');
      }

      EvaluationModel evaluation;
      String discipline;
      List<QuestionModel> questions;

      final docReference = _storeInstance
          .collection('evaluation')
          .where('code', isEqualTo: code);

      if (docReference == null) {
        return evaluation;
      }

      QuerySnapshot docsData = await docReference.getDocuments();
      final document =
          docsData.documents.firstWhere((doc) => doc.data['status'] == 'A');

      if (document != null) {
        discipline =
            await getDisciplineDescription(document.data['discipline']);

        questions = await getQuestions(document.data['question']);
        final totalTime = TimeOfDay.fromDateTime(
            DateTime.fromMillisecondsSinceEpoch(
                (totalTimeQuestions / 1000).floor()));
        evaluation = EvaluationModel(
          status: document.data['status'],
          code: document.data['code'],
          grade: document.data['grade'],
          createdAt: document.data['create_at'],
          title: document.data['title'],
          discipline: discipline ?? '',
          initialDate: document.data['initial_date'],
          finalDate: document.data['final_date'],
          question: questions,
          totalQuestions: totalQuestions,
          totalTime: totalTime,
          stageEducation: document.data['stage_education'],
          user: document.data['user'],
        );

        return evaluation;
      }
    } on PlatformException catch (error) {
      throw error;
    } on InternetException catch (error) {
      throw error;
    } on Exception catch (error) {
      throw Exception('Houve erro ao tentar acessar a avaliação solicitada' +
          error.toString());
    }
  }

  Future<String> getDisciplineDescription(String disciplineRef) async {
    final disciplineData = await _storeInstance.document(disciplineRef).get();

    if (disciplineData != null && disciplineData.data['active'] == true) {
      return disciplineData.data['name'];
    } else {
      return null;
    }
  }

  Future<List<QuestionModel>> getQuestions(String questionsRef) async {
    List<QuestionModel> questions;

    final questionsData = await _storeInstance.document(questionsRef).get();
    if (questionsData != null) {
      questionsData.data.forEach((index, question) {
        if (question['active'] == true) {
          totalQuestions++;
          totalTimeQuestions += question['response_time'];
          questions.add(QuestionModel(
            active: question['active'],
            answer: question['answer'],
            bncc: question['bncc'],
            createdAt: question['created_at'],
            description: question['description'],
            difficulty: question['difficulty'],
            questionType: question['question_type'],
            responseTime: question['response_time'],
            tip: question['tip'],
          ));
        }
      });
    }

    return questions;
  }
}
