import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:file/local.dart';
import 'package:path/path.dart';

import 'simple_ast_visitor.dart';

/// 装饰其他AstVisitor，统计耗时

void main(List<String> arguments) {
  var fileSystem = const LocalFileSystem();
  var filePath =
      join(fileSystem.currentDirectory.parent.path, "lib", "main.dart");
  var unit =
      parseFile(path: filePath, featureSet: FeatureSet.latestLanguageVersion())
          .unit;
  var visitor = TimedAstVisitor(MySimpleAstVisitor());
  unit.accept(visitor);
  print('elapsed ${visitor.stopwatch.elapsed.toString()}');
}
