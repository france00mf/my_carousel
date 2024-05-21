import 'package:my_carousel/data_constant.dart';

String getBackdropUrl(String? path) {
  if (path != null) {
    return DataConstants.image + path;
  } else {
    return DataConstants.moviePlaceHolder;
  }
}