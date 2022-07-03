# [ModestPagination](https://pub.dev/packages/modest_pagination/)

<img src="https://img.shields.io/pub/v/modest_pagination?style=for-the-badge">
<img src="https://img.shields.io/github/last-commit/iamngoni/modest-pagination">
<img src="https://img.shields.io/twitter/url?label=iamngoni_&style=social&url=https%3A%2F%2Ftwitter.com%2Fiamngoni_">

This is a simple to use pagination component (that most suites my needs and may fit into your needs too)

## Usage
### Add dependency
```yaml
dependencies:
  modest_pagination: <version>
```

### Or
```shell
flutter pub add modest_pagination
```

### Import package
```dart
  import 'package:modest_pagination/modest_pagination.dart';
```

### Usage

```dart
ModestPagination(
  items: countries,
  itemsPerPage: 8,
  pagesPerSheet: 6,
  activeTextColor: Colors.white,
  inactiveTextColor: Colors.white70,
  pagesControllerIconsColor: Colors.white,
  sheetsControllerIconsColor: Colors.white,
  useListView: true,
  childWidget: (T element) {
    return Container();
    },
)
```

Check example for more details

## Screenshot
<table>
   <tr>
      <td>GridView</td>
      <td>ListView</td>
   </tr>
   <tr>
      <td><img src="https://res.cloudinary.com/iamngoni/image/upload/v1656880214/Screenshot_1656876797_vunths.png"/></td>
      <td><img src="https://res.cloudinary.com/iamngoni/image/upload/v1656880454/Screenshot_1656880434_yw5dhq.png"/></td>
   </tr>
</table>
