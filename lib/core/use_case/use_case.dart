import 'package:dartz/dartz.dart';

abstract class UseCase<T, Map> {
  Future<Either<Error, T>> call(Map data);
}
