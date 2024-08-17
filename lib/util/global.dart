import 'package:logger/logger.dart';
import 'package:meta_bio/domain/profile.dart';
import 'package:meta_bio/util/observable.dart';

final globalProfileObservable = Observable<Profile?>(null);

final logger = Logger();
