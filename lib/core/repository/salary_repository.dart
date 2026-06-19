
import '../model/salary_model.dart';
import '../services/salary_api_service.dart';

class SalaryRepository {
  final SalaryApiService apiService;

  SalaryRepository(this.apiService);

  Future<SalaryResponse> getSalary({
    required String userAutoId,
    required String startMonth,
    required String endMonth,
  }) async {
    final result = await apiService.fetchSalary(
      userAutoId: userAutoId,
      startMonth: startMonth,
      endMonth: endMonth,
    );

     return SalaryResponse.fromJson(result);
  }
}