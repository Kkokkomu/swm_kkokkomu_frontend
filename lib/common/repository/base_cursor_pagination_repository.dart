import 'package:swm_kkokkomu_frontend/common/model/additional_params.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_params.dart';
import 'package:swm_kkokkomu_frontend/common/model/model_with_id.dart';
import 'package:swm_kkokkomu_frontend/common/model/response_model.dart';

abstract class IBaseCursorPaginationRepository<T extends IModelWithId> {
  Future<ResponseModel<CursorPagination<T>>> paginate(
    CursorPaginationParams cursorPaginationParams, {
    AdditionalParams? additionalParams,
    String apiPath = '',
  });
}
