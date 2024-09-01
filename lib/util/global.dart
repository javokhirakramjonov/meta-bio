import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:meta_bio/domain/profile.dart';
import 'package:meta_bio/util/logger_helper.dart';
import 'package:meta_bio/util/observable.dart';

final globalProfileObservable = Observable<Profile?>(null);

final logger = Logger(filter: DebugLogFilter());

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
