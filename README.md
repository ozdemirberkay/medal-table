
# Medal Table
A medal table showing ranking

## Samples
![ucl](https://github.com/user-attachments/assets/ea36a0be-a054-45f8-b369-cf59d31fc5f1)

![imdb](https://github.com/user-attachments/assets/a535d420-cdd1-4ed8-9476-4885a488d6dd)

## Usage Example
```
        MedalTable(
          headerDecoration: BoxDecoration(
            color: const Color(0xff091442),
            borderRadius: BorderRadius.circular(6),
          ),
          headerTextStyle: const TextStyle(
            fontSize: 18,
            color: Color(0xff6594C0),
          ),
          labelTitle: "Team",
          leadingTitle: "Rank",
          valueTitle: "UCL Title",
          firstItem: TableItemModel(title: "Real Marid", value: 15),
          secondItem: TableItemModel(title: "Milan", value: 7),
          thirdItem: TableItemModel(title: "Liverpool", value: 6),
          itemTextStyle: const TextStyle(
            fontSize: 16,
            color: Color(0xff091442),
          ),
        );
```

## Installation
[Installing](https://pub.dev/packages/medal_table/install)

