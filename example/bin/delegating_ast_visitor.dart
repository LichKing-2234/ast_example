import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:file/local.dart';
import 'package:path/path.dart';

/// delegate如果override则无需调用super，否则会visit同一个node多次（并不绝对，取决于需求）
/// delegate的visitNode不会被触发

class ImportAstVisitor extends SimpleAstVisitor<Object?> {
  @override
  Object? visitImportDirective(ImportDirective node) {
    print('${runtimeType.toString()}: visitImportDirective ${node.toSource()}');
    // return super.visitImportDirective(node);
  }
}

class FunctionAstVisitor extends SimpleAstVisitor<Object?> {
  @override
  Object? visitFunctionDeclaration(FunctionDeclaration node) {
    print('${runtimeType.toString()}: visitFunctionDeclaration ${node.name}');
    // return super.visitFunctionDeclaration(node);
  }
}

class ClassAstVisitor extends SimpleAstVisitor<Object?> {
  @override
  Object? visitClassDeclaration(ClassDeclaration node) {
    print('${runtimeType.toString()}: visitClassDeclaration ${node.name}');
    // return super.visitClassDeclaration(node);
  }

  @override
  Object? visitConstructorDeclaration(ConstructorDeclaration node) {
    print('${runtimeType.toString()}: visitConstructorDeclaration ${node.name} '
        '${(node.parent is ClassDeclaration ? node.parent as ClassDeclaration : null)?.name}');
    // return super.visitConstructorDeclaration(node);
  }

  @override
  Object? visitVariableDeclarationList(VariableDeclarationList node) {
    print('${runtimeType.toString()}: visitVariableDeclarationList '
        '${(node.type is NamedType ? node.type as NamedType : null)?.name} '
        '${node.variables.first.name}');
    // return super.visitVariableDeclarationList(node);
  }

  @override
  Object? visitMethodDeclaration(MethodDeclaration node) {
    print('${runtimeType.toString()}: visitMethodDeclaration ${node.name} '
        '${(node.parent is ClassDeclaration ? node.parent as ClassDeclaration : null)?.name}');
    // return super.visitMethodDeclaration(node);
  }
}

void main(List<String> arguments) {
  var fileSystem = const LocalFileSystem();
  var filePath =
      join(fileSystem.currentDirectory.parent.path, "lib", "main.dart");
  var unit =
      parseFile(path: filePath, featureSet: FeatureSet.latestLanguageVersion())
          .unit;
  var visitor = DelegatingAstVisitor([
    ImportAstVisitor(),
    FunctionAstVisitor(),
    ClassAstVisitor(),
  ]);
  unit.accept(visitor);
}
