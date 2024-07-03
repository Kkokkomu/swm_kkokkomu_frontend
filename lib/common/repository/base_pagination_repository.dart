import 'package:swm_kkokkomu_frontend/common/model/additional_params.dart';
import 'package:swm_kkokkomu_frontend/common/model/offset_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/model/pagination_params.dart';
import 'package:swm_kkokkomu_frontend/common/model/response_model.dart';

abstract class BasePaginationRepository<T> {
  Future<ResponseModel<OffsetPagination<T>>> paginate({
    required PaginationParams paginationParams,
    AdditionalParams? additionalParams,
  });
}
