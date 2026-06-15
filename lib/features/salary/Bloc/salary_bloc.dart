import 'package:flutter_bloc/flutter_bloc.dart';


 import '../../../core/repository/salary_repository.dart';
import 'salary_event.dart';
import 'salary_state.dart';

class SalaryBloc extends Bloc<SalaryEvent, SalaryState> {
  final SalaryRepository repository;

  SalaryBloc(this.repository) : super(SalaryInitial()) {
    on<FetchSalaryEvent>(_onFetchSalary);
  }

  Future<void> _onFetchSalary(
      FetchSalaryEvent event,
      Emitter<SalaryState> emit,
      ) async {
    emit(SalaryLoading());

    try {
      final response = await repository.getSalary(
        userAutoId: event.userAutoId,
        startMonth: event.startMonth,
        endMonth: event.endMonth,
      );

      emit(SalaryLoaded(response));
    } catch (e) {
      emit(SalaryError(e.toString()));
    }
  }
}