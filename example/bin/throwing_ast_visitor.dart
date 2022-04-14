import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:file/local.dart';
import 'package:path/path.dart';

/// 如果override则不能调用super，负责会抛异常
/// 无visitNode
/// 需手动accept

class MyThrowingAstVisitor extends ThrowingAstVisitor<Object?> {
  @override
  Object? visitCompilationUnit(CompilationUnit node) {
    for (var element in node.directives) {
      if (element is ImportDirective) {
        element.accept(this);
      }
    }
    for (var element in node.declarations) {
      if (element is FunctionDeclaration || element is ClassDeclaration) {
        element.accept(this);
      }
    }
  }

  @override
  Object? visitImportDirective(ImportDirective node) {
    print('${runtimeType.toString()}: visitImportDirective ${node.toSource()}');
  }

  @override
  Object? visitFunctionDeclaration(FunctionDeclaration node) {
    print('${runtimeType.toString()}: visitFunctionDeclaration ${node.name}');
  }

  @override
  Object? visitClassDeclaration(ClassDeclaration node) {
    print('${runtimeType.toString()}: visitClassDeclaration ${node.name}');
    for (var element in node.members) {
      if (element is ConstructorDeclaration ||
          element is FieldDeclaration ||
          element is MethodDeclaration) {
        element.accept(this);
      }
    }
  }

  @override
  Object? visitConstructorDeclaration(ConstructorDeclaration node) {
    print('${runtimeType.toString()}: visitConstructorDeclaration ${node.name} '
        '${(node.parent is ClassDeclaration ? node.parent as ClassDeclaration : null)?.name}');
  }

  @override
  Object? visitFieldDeclaration(FieldDeclaration node) {
    node.fields.accept(this);
  }

  @override
  Object? visitVariableDeclarationList(VariableDeclarationList node) {
    print('${runtimeType.toString()}: visitVariableDeclarationList '
        '${(node.type is NamedType ? node.type as NamedType : null)?.name} '
        '${node.variables.first.name}');
  }

  @override
  Object? visitMethodDeclaration(MethodDeclaration node) {
    print('${runtimeType.toString()}: visitMethodDeclaration ${node.name} '
        '${(node.parent is ClassDeclaration ? node.parent as ClassDeclaration : null)?.name}');
  }
}

void main(List<String> arguments) {
  var fileSystem = const LocalFileSystem();
  var filePath =
      join(fileSystem.currentDirectory.parent.path, "lib", "main.dart");
  var unit =
      parseFile(path: filePath, featureSet: FeatureSet.latestLanguageVersion())
          .unit;
  var visitor = MyThrowingAstVisitor();
  unit.accept(visitor);
}
